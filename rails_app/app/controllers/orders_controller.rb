class OrdersController < ApplicationController
  # POST /orders
  # params: { user_id:, use_points:, items: [{ product_id:, quantity: }] }
  def create
    @user = User.find(params[:user_id])
    items_params = params[:items] || []
    use_points = params[:use_points].to_i

    # ====================================
    # ここから下がリファクタリング対象
    # ====================================

    # 在庫チェック
    items_params.each do |item|
      product = Product.find(item[:product_id])
      if product.stock < item[:quantity].to_i
        render json: { error: "#{product.name}の在庫が不足しています" }, status: :unprocessable_entity
        return
      end
    end

    # 合計金額を計算
    total = 0
    items_params.each do |item|
      product = Product.find(item[:product_id])
      total += product.price * item[:quantity].to_i
    end

    # ポイント利用のバリデーション
    if use_points > @user.points
      render json: { error: "ポイントが不足しています" }, status: :unprocessable_entity
      return
    end

    if use_points > total
      render json: { error: "利用ポイントが合計金額を超えています" }, status: :unprocessable_entity
      return
    end

    # ポイント利用後の支払い金額
    payment_amount = total - use_points

    # 獲得ポイントを計算（支払い金額の1%、小数点以下切り捨て）
    earned_points = (payment_amount * 0.01).floor

    # 注文を作成
    @order = Order.new(
      user: @user,
      status: 'confirmed',
      total_amount: total,
      used_points: use_points,
      earned_points: earned_points
    )

    ActiveRecord::Base.transaction do
      @order.save!

      # 注文明細を作成
      items_params.each do |item|
        product = Product.find(item[:product_id])
        @order.order_items.create!(
          product: product,
          quantity: item[:quantity].to_i,
          unit_price: product.price
        )

        # 在庫を減らす
        product.update!(stock: product.stock - item[:quantity].to_i)
      end

      # ユーザーのポイントを更新
      new_points = @user.points - use_points + earned_points
      @user.update!(points: new_points)
    end

    # メール送信（実際にはここでメーラーを呼ぶ）
    Rails.logger.info("注文確認メールを送信: #{@user.email}")
    Rails.logger.info("注文ID: #{@order.id}, 合計: #{total}円, 利用ポイント: #{use_points}, 獲得ポイント: #{earned_points}")

    render json: {
      order_id: @order.id,
      total_amount: total,
      used_points: use_points,
      payment_amount: payment_amount,
      earned_points: earned_points
    }, status: :created
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: "リソースが見つかりません" }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
