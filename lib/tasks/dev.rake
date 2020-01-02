namespace :dev do
    desc "Configura o Ambiente de desenvolvimento"
    task setup: :environment do
        if Rails.env.development?
            showSpinner("APAGANDO banco de dados...") { %x(rails db:drop) }
            showSpinner("CRIANDO banco de dados...") { %x(rails db:create) }
            showSpinner("MIGRANDO os dados...") { %x(rails db:migrate) }
            %x(rails dev:addMiningTypes)
            %x(rails dev:addCoins)
        else
            puts "Você não está em ambiente de desenvolvimento"
        end
    end

    # CADASTRO DE MOEDAS #
    desc "Cadastra as Moedas"
    task addCoins: :environment do
        if Rails.env.development?
            showSpinner("CADASTRANDO Moedas...") do
                coins = [
                    {
                        description: "Bitcoin",
                        acronym: "BTC",
                        url_image: "https://pngimg.com/uploads/bitcoin/bitcoin_PNG47.png",
                        mining_type: MiningType.find_by(acronym: 'PoW')
                    },
                    {
                        description: "Ethereum",
                        acronym: "ETH",
                        url_image: "https://cdn4.iconfinder.com/data/icons/cryptocoins/227/ETH-alt-512.png",
                        mining_type: MiningType.all.sample
                    },
                    {
                        description: "Dash",
                        acronym: "DASH",
                        url_image: "https://criptohub.com.br/assets/svg/svg006.svg",
                        mining_type: MiningType.all.sample
                    },
                    {
                        description: "Iota",
                        acronym: "IOT",
                        url_image: "https://cdn4.iconfinder.com/data/icons/crypto-currency-and-coin-2/256/IOTA_iotacoin_coin-512.png",
                        mining_type: MiningType.all.sample
                    },
                    {
                        description: "ZCash",
                        acronym: "ZEC",
                        url_image: "https://z.cash/wp-content/uploads/2019/03/zcash-icon-fullcolor.png",
                        mining_type: MiningType.all.sample
                    }
                ]
                coins.each do |coin|
                    Coin.find_or_create_by!(coin)
                end
            end
        else
            puts "Você não está em ambiente de desenvolvimento"
        end
    end

    # CADASTRO DE TIPOS DE MINERAÇÃO #
    desc "Cadastra os tipos de mineração"
    task addMiningTypes: :environment do
        if Rails.env.development?
            showSpinner("CADASTRANDO tipos de mineração...") do
                miningTypes = [
                    { description: "Proof of Work", acronym: "PoW" },
                    { description: "Proof of Stake", acronym: "PoS" },
                    { description: "Proof of Capacity", acronym: "PoC" }
                ]
                miningTypes.each do |miningType|
                    MiningType.find_or_create_by!(miningType)
                end
            end
        else
            puts "Você não está em ambiente de desenvolvimento"
        end
    end

    private
        def showSpinner(msgStart, msgEnd = "Concluído")
            spinner = TTY::Spinner.new("[:spinner] #{msgStart}", format: :dots)
            spinner.auto_spin
            yield
            spinner.success("(#{msgEnd})")
        end
end
