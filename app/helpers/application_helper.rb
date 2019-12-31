module ApplicationHelper
    def dateBR(dateUS)
        dateUS.strftime("%d/%m/%Y")
    end

    def railsEnv
        if Rails.env.development?
            "Desenvolvimento"
        elsif Rails.env.production?
            "Produção"
        else
            "Teste"
        end
    end
end
