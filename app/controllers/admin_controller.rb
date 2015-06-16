class AdminController < ApplicationController
    def new
        @admin = User.new
    end

    def create
        admin = params[:admin]
        admin[:count] = 0
        admin[:score] = 0.0
        params[:admin] = admin
        p admin
        @admin = User.new(admin_params)
        if @admin.save
            redirect_to '/'
        else
            render 'new'
        end
    end

    def edit
        name = params[:name]
        @admin = User.find_by(username: name)
    end

    def update
        admin_hash = params[:admin]
        @admin = User.find_by(username: admin_hash[:username])
        if @admin.update(admin_params)
            redirect_to '/'
        else
            render 'edit'
        end
    end

    def destroy
        name = params[:name]
        admin = User.find_by(username: name)
        admin.destroy
        redirect_to '/'
    end

    private
    def admin_params
        params.require(:admin).permit(:username, :password, :password_confirmation, :role, :org, :count, :score)
    end
end
