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
            redirect_to @order, notice: '报修单创建成功!'
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
            @orders = Order.where("org = ?", current_user.org)
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
        @order = Order.find(params[:id])
    end

    def update
        @order = Order.find(params[:id])
        order_hash = params[:order]
        @order.suggestion = order_hash[:suggestion]
        @order.status = "已处理"
        OrderMailer.repair_email(@order).deliver_now!
        if @order.save
            redirect_to @order
        else
            render 'suggest'
        end
    end

    def comment
        @order = Order.find(params[:id])
    end

    def update_comment
        @order = Order.find(params[:id])
        order_hash = params[:order]
        @order.score = order_hash[:score]
        @order.status = "已评价"

        repairman = User.find_by(username: @order.repairman)
        repairman.count += 1
        repairman.score = (repairman.score * (repairman.count-1) + params[:order][:score].to_i) / repairman.count
        repairman.save
        if @order.save
            redirect_to @order
        else
            render 'suggest'
        end
    end

    private
    def order_params
        params.require(:order).permit(:title, :persion, :phone, :email, :text, :org, :repairman, :suggestion, :status, :comment, :provider, :position, :score, :avatar)
    end
end
