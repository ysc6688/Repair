class OrdersController < ApplicationController
    def new
        @order = Order.new
    end

    def create
        order_hash = params[:order]
        order_hash[:provider] = current_user.username
        order_hash[:repairman] = ""
        order_hash[:suggestion] = ""
        order_hash[:status] = "已提交"
        order_hash[:comment] = ""
        params[:order] = order_hash
        @order = Order.new(order_params)
        if @order.save
            redirect_to @order, notice: '保修单创建成功!'
        else
            render 'new'
        end
    end

    def show
        @order = Order.find(params[:id])
        if current_user.org == @order.org || @order.provider == current_user.username
        else
            redirect_to '/'
        end
    end

    def index
        if current_user.role == 'student'
            @orders = Order.where("provider = ?", current_user.username)
        elsif current_user.role == 'root'
            @users = User.where("role = ? OR role = ?", 'manager', 'repairman')
        elsif current_user.role == 'manager'
            @orders = Order.where("org = ? AND status = ?", current_user.org, '已提交')
            @repairmans = User.where("role = ? AND org = ?", 'repairman', current_user.org)
        else
            @orders = Order.where("repairman = ?", current_user.username)
        end
    end

    def alloc
        order = Order.find(params[:orderid])
        order.repairman = params[:rp]
        order.status = "已指派"
        order.save
        respond_to do |format|
          if order.errors.any?
            format.json { render json: {msg: order.errors.full_messages} }
          else
            format.json { render json: {msg: '指派维修员成功!' } }
          end
        end
    end

    def circle
        order = Order.find(params[:orderid])
        order.org = params[:org]
        order.repairman = ""
        order.status = "已提交"
        order.save
        respond_to do |format|
          if order.errors.any?
            format.json { render json: {msg: order.errors.full_messages} }
          else
            format.json { render json: {msg: '流转成功!' } }
          end
        end
    end

    def suggest
        @order = Order.new
    end

    private
    def order_params
        params.require(:order).permit(:title, :persion, :phone, :email, :text, :org, :repairman, :suggestion, :status, :comment, :provider)
    end
end
