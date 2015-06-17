class OrderMailer < ApplicationMailer
    default from: 'yinshucheng8@163.com'

    def repair_email(order)
        @order = order
        @url = 'http://localhost:3000/orders/' + @order.id.to_s
        mail(to: @order.email, subject: '您的报修单已经成功受理，请及时评价!')
    end
end
