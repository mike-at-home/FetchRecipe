import Foundation

public enum Model { }

extension Model {
    public struct RecipeList: Codable {
        public var recipes: [Recipe]
    }

    // MARK: - Recipe

    public struct Recipe: Codable, Identifiable {
        public var id: UUID

        public var name: String
        public var cuisine: Cuisine
        public var source: URL?
        public var smallPhoto: URL?
        public var largePhoto: URL?
        public var youTube: URL?

        public enum CodingKeys: String, CodingKey {
            case cuisine
            case name
            case largePhoto = "photo_url_large"
            case smallPhoto = "photo_url_small"
            case source = "source_url"
            case id = "uuid"
            case youTube = "youtube_url"
        }
    }

    public enum Cuisine: Codable {
        case known(KnownCuisine)
        case unknown(String)

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            let stringValue = try container.decode(String.self)

            if let knownCuisine = KnownCuisine(demonym: stringValue) {
                self = .known(knownCuisine)
            } else {
                self = .unknown(stringValue)
            }
        }

        public func encode(to encoder: any Encoder) throws {
            switch self {
            case let .known(value):
                try value.demonym.encode(to: encoder)
            case let .unknown(value):
                try value.encode(to: encoder)
            }
        }

        public init(demonym: String) {
            if let known = KnownCuisine(demonym: demonym) {
                self = .known(known)
            } else {
                self = .unknown(demonym)
            }
        }

        public var demonym: String {
            switch self {
            case let .known(value): return value.demonym
            case let .unknown(value): return value
            }
        }

        public var text: String {
            switch self {
            case let .known(value): return "\(value.flag) \(value.demonym)"
            case let .unknown(value): return value
            }
        }
    }

    public struct KnownCuisine: CaseIterable {
        public var demonym: String
        public var flag: String

        public static let malaysian: Self = .init(demonym: "Malaysian", flag: "🇲🇾")
        public static let british: Self = .init(demonym: "British", flag: "🇬🇧")
        public static let american: Self = .init(demonym: "American", flag: "🇺🇸")
        public static let canadian: Self = .init(demonym: "Canadian", flag: "🇨🇦")
        public static let french: Self = .init(demonym: "French", flag: "🇫🇷")
        public static let polish: Self = .init(demonym: "Polish", flag: "🇵🇱")
        public static let russian: Self = .init(demonym: "Russian", flag: "🇷🇺")
        public static let tunisian: Self = .init(demonym: "Tunisian", flag: "🇹🇳")
        public static let croatian: Self = .init(demonym: "Croatian", flag: "🇭🇷")

        public static let allCases: [Self] = [
            .malaysian, .british, .american, .canadian, .french, .polish, .russian, .tunisian, .croatian,
        ]
    }
}

extension Model.KnownCuisine {
    private static let demonymMap: [String: Self] = allCases.reduce(into: [:]) { result, caseInfo in
        result[caseInfo.self.demonym] = caseInfo
    }

    public init?(demonym: String) {
        if let knownCuisine = Self.demonymMap[demonym] {
            self = knownCuisine
        } else {
            return nil
        }
    }
}

extension Model.Recipe {
    init(
        id: String,
        name: String,
        cuisine: String,
        source: String? = nil,
        smallPhoto: String? = nil,
        largePhoto: String? = nil,
        youTube: String? = nil
    ) {
        self.init(
            id: .init(uuidString: id)!,
            name: name,
            cuisine: .init(demonym: cuisine),
            source: source.flatMap(URL.init(string:)),
            smallPhoto: smallPhoto.flatMap(URL.init(string:)),
            largePhoto: largePhoto.flatMap(URL.init(string:)),
            youTube: youTube.flatMap(URL.init(string:))
        )
    }
}

extension Model.RecipeList {
    internal static let testList: Self = .init(recipes: [
        .init(
            id: "599344f4-3c5c-4cca-b914-2210e3b3312f",
            name: "Apple & Blackberry Crumble",
            cuisine: "British",
            source: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
            youTube: "https://www.youtube.com/watch?v=4vhcOwVBDO4"
        ),
        .init(
            id: "74f6d4eb-da50-4901-94d1-deae2d8af1d1",
            name: "Apple Frangipan Tart",
            cuisine: "British",
            youTube: "https://www.youtube.com/watch?v=rp8Slv4INLk"
        ),
        .init(
            id: "eed6005f-f8c8-451f-98d0-4088e2b40eb6",
            name: "Bakewell Tart",
            cuisine: "British",
            youTube: "https://www.youtube.com/watch?v=1ahpSTf_Pvk"
        ),
        .init(
            id: "f8b20884-1e54-4e72-a417-dabbc8d91f12",
            name: "Banana Pancakes",
            cuisine: "American",
            source: "https://www.bbcgoodfood.com/recipes/banana-pancakes",
            youTube: "https://www.youtube.com/watch?v=kSKtb2Sv-_U"
        ),
        .init(
            id: "891a474e-91cd-4996-865e-02ac5facafe3",
            name: "Battenberg Cake",
            cuisine: "British",
            source: "https://www.bbcgoodfood.com/recipes/1120657/battenberg-cake",
            youTube: "https://www.youtube.com/watch?v=aB41Q7kDZQ0"
        ),
        .init(
            id: "b5db2c09-411e-4bdf-9a75-a194dcde311b",
            name: "BeaverTails",
            cuisine: "Canadian",
            source: "https://www.tastemade.com/videos/beavertails",
            youTube: "https://www.youtube.com/watch?v=2G07UOqU2e8"
        ),
        .init(
            id: "8938f16a-954c-4d65-953f-fa069f3f1b0d",
            name: "Blackberry Fool",
            cuisine: "British",
            source: "https://www.bbc.co.uk/food/recipes/blackberry_fool_with_11859",
            youTube: "https://www.youtube.com/watch?v=kniRGjDLFrQ"
        ),
        .init(
            id: "02a80f95-09d6-430c-a9da-332584229d6f",
            name: "Bread and Butter Pudding",
            cuisine: "British",
            source: "https://cooking.nytimes.com/recipes/1018529-coq-au-vin",
            youTube: "https://www.youtube.com/watch?v=Vz5W1-BmOE4"
        ),
        .init(
            id: "563dbb27-5323-443c-b30c-c221ae598568",
            name: "Budino Di Ricotta",
            cuisine: "Italian",
            source: "https://thehappyfoodie.co.uk/recipes/ricotta-cake-budino-di-ricotta",
            youTube: "https://www.youtube.com/watch?v=6dzd6Ra6sb4"
        ),
        .init(
            id: "39ad8233-c470-4394-b65f-2a6c3218b935",
            name: "Canadian Butter Tarts",
            cuisine: "Canadian",
            source: "https://www.bbcgoodfood.com/recipes/1837/canadian-butter-tarts",
            youTube: "https://www.youtube.com/watch?v=WUpaOGghOdo"
        ),
        .init(
            id: "7e529e52-f56d-49a2-938f-81aac853cc65",
            name: "Carrot Cake",
            cuisine: "British",
            source: "https://www.bbc.co.uk/food/recipes/classic_carrot_cake_08513",
            youTube: "https://www.youtube.com/watch?v=asjZ7iTrGKA"
        ),
        .init(
            id: "7eeb0865-b41c-4a3b-80dd-a69d32dccc7d",
            name: "Cashew Ghoriba Biscuits",
            cuisine: "Tunisian",
            source: "http://allrecipes.co.uk/recipe/40152/cashew-ghoriba-biscuits.aspx",
            youTube: "https://www.youtube.com/watch?v=IqXEZUk4hWI"
        ),
        .init(
            id: "7fc217a9-5566-4bf1-b1ce-13bc9e3f2b1a",
            name: "Chelsea Buns",
            cuisine: "British",
            source: "https://www.bbc.co.uk/food/recipes/chelsea_buns_95015",
            youTube: "https://www.youtube.com/watch?v=i_zemP3yBKw"
        ),
        .init(
            id: "6377de22-4ec2-44c4-9e76-260be2e4fd90",
            name: "Chinon Apple Tarts",
            cuisine: "French",
            source: "https://www.bbcgoodfood.com/recipes/chinon-apple-tarts",
            youTube: "https://www.youtube.com/watch?v=5dAW9HQgtCk"
        ),
        .init(
            id: "6a3f96c1-02db-412a-ab7c-bb69b1bb4a8a",
            name: "Choc Chip Pecan Pie",
            cuisine: "American",
            source: "https://www.bbcgoodfood.com/recipes/choc-chip-pecan-pie",
            youTube: "https://www.youtube.com/watch?v=fDpoT0jvg4Y"
        ),
        .init(
            id: "b07b8b92-64c9-4322-ab15-e628a1b8fcbc",
            name: "Chocolate Avocado Mousse",
            cuisine: "British",
            source: "http://www.hemsleyandhemsley.com/recipe/chocolate-avocado-mousse/",
            youTube: "https://www.youtube.com/watch?v=wuZffe60q4M"
        ),
        .init(
            id: "1bf34a8c-4579-479f-91e0-6eed354f6b2c",
            name: "Chocolate Caramel Crispy",
            cuisine: "British",
            source: "http://www.donalskehan.com/recipes/chocolate-caramel-rice-crispy-treats/",
            youTube: "https://www.youtube.com/watch?v=qsk_At_gjv0"
        ),
        .init(
            id: "7e9fc2d3-9759-46ee-976e-d6ca0f682091",
            name: "Chocolate Gateau",
            cuisine: "French",
            source: "http://www.goodtoknow.co.uk/recipes/536028/chocolate-gateau",
            youTube: "https://www.youtube.com/watch?v=dsJtgmAhFF4"
        ),
        .init(
            id: "606f22ce-fcd1-434e-a6da-9571c0b2fc9b",
            name: "Chocolate Raspberry Brownies",
            cuisine: "American",
            source: "https://www.bbcgoodfood.com/recipes/2121648/bestever-chocolate-raspberry-brownies",
            youTube: "https://www.youtube.com/watch?v=Pi89PqsAaAg"
        ),
        .init(
            id: "003cd03a-6e93-48ba-aa3d-0f53f40569ad",
            name: "Chocolate Souffle",
            cuisine: "French",
            source: "https://www.bbcgoodfood.com/recipes/5816/hot-chocolate-souffls-with-chocolate-cream-sauce",
            youTube: "https://www.youtube.com/watch?v=FWqfkUEWOTg"
        ),
        .init(
            id: "a4139f76-e677-4092-ba69-5d4c5134d9d8",
            name: "Christmas Pudding Flapjack",
            cuisine: "British",
            youTube: "https://www.youtube.com/watch?v=OaqvGvEiwzU"
        ),
        .init(
            id: "e48c39c5-793d-491a-9c29-9417dc5e7e1c",
            name: "Christmas Pudding Trifle",
            cuisine: "British",
            source: "https://www.bbcgoodfood.com/recipes/1826685/christmas-pudding-trifle",
            youTube: "https://www.youtube.com/watch?v=jRfyNQs5qhU"
        ),
        .init(
            id: "088ac6dc-9804-483d-aa2e-845263daf90a",
            name: "Christmas Cake",
            cuisine: "British",
            source: "https://www.bbcgoodfood.com/recipes/angela-nilsens-christmas-cake",
            youTube: "https://www.youtube.com/watch?v=34yeL8TstO0"
        ),
        .init(
            id: "d603f36e-7aae-4a51-a96a-6711f582de19",
            name: "Classic Christmas Pudding",
            cuisine: "British",
            source: "https://www.bbcgoodfood.com/recipes/classic-christmas-pudding",
            youTube: "https://www.youtube.com/watch?v=Pb_lJxL1vtk"
        ),
        .init(
            id: "6b628dfc-5473-4924-b80c-5718cdae8b2a",
            name: "Dundee Cake",
            cuisine: "British",
            source: "https://www.bbcgoodfood.com/recipes/2155640/dundee-cake",
            youTube: "https://www.youtube.com/watch?v=4hEXsfpeMQE"
        ),
        .init(
            id: "265454f1-d1a6-470c-bc20-1d9ba73c8073",
            name: "Eccles Cakes",
            cuisine: "British",
            source: "https://www.bbcgoodfood.com/recipes/786659/eccles-cakes",
            youTube: "https://www.youtube.com/watch?v=xV0QCJ0GD5w"
        ),
        .init(
            id: "1a86ef7d-a9f1-44c1-a4a0-2278f5916d49",
            name: "Eton Mess",
            cuisine: "British",
            youTube: "https://www.youtube.com/watch?v=43WgiNq54L8"
        ),
        .init(
            id: "98c27533-a823-426d-8639-a2b334ec659a",
            name: "Honey Yogurt Cheesecake",
            cuisine: "Greek",
            source: "https://www.bbcgoodfood.com/recipes/honey-yogurt-cheesecake",
            youTube: "https://www.youtube.com/watch?v=JE8crtueXs8"
        ),
        .init(
            id: "a43f53ea-4d06-46c1-bd20-5d8e487ea52b",
            name: "Hot Chocolate Fudge",
            cuisine: "American",
            youTube: "https://www.youtube.com/watch?v=oJvbsVSblfk"
        ),
        .init(
            id: "338c1c7b-656a-4166-8a17-a7f99c6119e2",
            name: "Jam Roly-Poly",
            cuisine: "British",
            source: "https://www.bbcgoodfood.com/recipes/13354/jam-rolypoly",
            youTube: "https://www.youtube.com/watch?v=5ZYWVQ8imVA"
        ),
        .init(
            id: "303ce395-af37-4cff-87b4-09c75a4e07ed",
            name: "Key Lime Pie",
            cuisine: "American",
            source: "https://www.bbcgoodfood.com/recipes/2155644/key-lime-pie",
            youTube: "https://www.youtube.com/watch?v=q4Rz7tUkX9A"
        ),
        .init(
            id: "9e230f96-f93d-4d29-9230-a1f5fd539464",
            name: "Krispy Kreme Donut",
            cuisine: "American",
            source: "https://www.mythirtyspot.com/krispy-kreme-copycat-recipe-for/",
            youTube: "https://www.youtube.com/watch?v=SamYg6IUGOI"
        ),
        .init(
            id: "36cf73a3-c505-4a68-b11a-977b2a02d83d",
            name: "Mince Pies",
            cuisine: "British",
            source: "https://www.bbcgoodfood.com/recipes/2174/unbelievably-easy-mince-pies",
            youTube: "https://www.youtube.com/watch?v=PnXft7lQNJE"
        ),
        .init(
            id: "19c33de0-c9ab-4692-b484-4d9c803b9424",
            name: "Nanaimo Bars",
            cuisine: "Canadian",
            source: "https://www.bbcgoodfood.com/recipes/nanaimo-bars",
            youTube: "https://www.youtube.com/watch?v=MMrE4I1ZtWo"
        ),
        .init(
            id: "b63fbae1-f5d1-41a7-a030-1a3a556f4c57",
            name: "New York Cheesecake",
            cuisine: "American",
            source: "https://www.bbcgoodfood.com/recipes/2869/new-york-cheesecake",
            youTube: "https://www.youtube.com/watch?v=tspdJ6hxqnc"
        ),
        .init(
            id: "fa4ad799-0706-4146-95a7-09f24b6dd1da",
            name: "Pancakes",
            cuisine: "American",
            source: "https://www.bbcgoodfood.com/recipes/2907669/easy-pancakes",
            youTube: "https://www.youtube.com/watch?v=LWuuCndtJr0"
        ),
        .init(
            id: "5de59157-f84b-4390-b8f4-ff19104782da",
            name: "Parkin Cake",
            cuisine: "British",
            source: "https://www.bbcgoodfood.com/recipes/1940684/parkin",
            youTube: "https://www.youtube.com/watch?v=k1lG4vk2MQA"
        ),
        .init(
            id: "cf8cbc60-2fce-4af8-8317-1736e9e116d1",
            name: "Peach & Blueberry Grunt",
            cuisine: "American",
            source: "https://www.bbcgoodfood.com/recipes/1553651/peach-and-blueberry-grunt",
            youTube: "https://www.youtube.com/watch?v=SNeO28BCpsc"
        ),
        .init(
            id: "ba8e2e4e-e1b3-4231-a663-eef155fabbdc",
            name: "Peanut Butter Cheesecake",
            cuisine: "American",
            source: "https://www.bbcgoodfood.com/recipes/1759649/peanut-butter-cheesecake",
            youTube: "https://www.youtube.com/watch?v=QSTsturcyL0"
        ),
        .init(
            id: "6b546d86-aaa6-47ff-a4e4-49836392f9b0",
            name: "Peanut Butter Cookies",
            cuisine: "American",
            source: "https://tasty.co/recipe/3-ingredient-peanut-butter-cookies",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/fa8fca0d-fd72-4f84-937d-2db66739f5b4/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/fa8fca0d-fd72-4f84-937d-2db66739f5b4/large.jpg"
        ),
        .init(
            id: "8925bfec-3ef5-4c56-a9d1-80e42654e0bf",
            name: "Pear Tarte Tatin",
            cuisine: "French",
            source: "https://www.bbcgoodfood.com/recipes/4778/pear-tarte-tatin",
            youTube: "https://www.youtube.com/watch?v=8U1tKWKDeWA"
        ),
        .init(
            id: "25a52168-29f8-4309-b48b-a96cae6ce867",
            name: "Polskie NaleÅ›niki (Polish Pancakes)",
            cuisine: "Polish",
            source: "https://www.tasteatlas.com/nalesniki/recipe",
            youTube: "https://www.youtube.com/watch?v=EZS4ev2crHc"
        ),
        .init(
            id: "630dec20-76a5-468b-9bd9-bfd170515204",
            name: "Portuguese Custard Tarts",
            cuisine: "Portuguese",
            source: "https://www.olivemagazine.com/recipes/baking-and-desserts/portuguese-custard-tarts/",
            youTube: "https://www.youtube.com/watch?v=lWLCxui1Mw8"
        ),
        .init(
            id: "11b2e8a4-7f4e-4b81-b8db-09ea2f10e9d3",
            name: "Pumpkin Pie",
            cuisine: "American",
            source: "https://www.bbcgoodfood.com/recipes/1742633/pumpkin-pie",
            youTube: "https://www.youtube.com/watch?v=hpapqEeb36k"
        ),
        .init(
            id: "cdc34bb5-c9e3-4465-9088-cf2e2aa8e4ee",
            name: "Rock Cakes",
            cuisine: "British",
            source: "https://www.bbc.co.uk/food/recipes/rock_cakes_03094",
            youTube: "https://www.youtube.com/watch?v=tY3taZO3Aro"
        ),
        .init(
            id: "fe81ba97-ee9e-4af9-bc3a-4f7a86eeb820",
            name: "Rocky Road Fudge",
            cuisine: "American",
            source: "http://tiphero.com/rocky-road-fudge/",
            youTube: "https://www.youtube.com/watch?v=N1aJ3nEYXyg"
        ),
        .init(
            id: "e084dc2c-37e7-4600-9b46-76e673e8e2d2",
            name: "Rogaliki (Polish Croissant Cookies)",
            cuisine: "Polish",
            source: "https://www.food.com/recipe/rogaliki-polish-croissant-cookies-with-jam-filling-200668",
            youTube: "https://www.youtube.com/watch?v=VAR10T9mfhU"
        ),
        .init(
            id: "23fb89ed-00ec-407e-8802-d0a510973df9",
            name: "Salted Caramel Cheescake",
            cuisine: "American",
            source: "http://www.janespatisserie.com/2015/11/09/no-bake-salted-caramel-cheesecake/",
            youTube: "https://www.youtube.com/watch?v=q5dQp3qpmI4"
        ),
        .init(
            id: "c4560eaa-3c0f-4266-beba-4ddce62063e0",
            name: "Seri Muka Kuih",
            cuisine: "Malaysian",
            source: "https://makan.ch/recipe/kuih-seri-muka/",
            youTube: "https://www.youtube.com/watch?v=_NJtCfqgaBo"
        ),
        .init(
            id: "2b9003b5-000d-445a-8b19-bbaed1b9f851",
            name: "Spotted Dick",
            cuisine: "British",
            source: "https://www.bbcgoodfood.com/recipes/2686661/spotted-dick",
            youTube: "https://www.youtube.com/watch?v=fu15XOF-ros"
        ),
        .init(
            id: "ee112b29-829b-45c6-8c3d-3effe739c9f0",
            name: "Sticky Toffee Pudding",
            cuisine: "British",
            source: "https://www.bbc.co.uk/food/recipes/marys_sticky_toffee_41970",
            youTube: "https://www.youtube.com/watch?v=Wytv3bjqJII"
        ),
        .init(
            id: "7365af2d-ab0b-4bab-a94f-462ffd752a09",
            name: "Sticky Toffee Pudding Ultimate",
            cuisine: "British",
            source: "https://www.youtube.com/watch?v=Wytv3bjqJII",
            youTube: "https://www.youtube.com/watch?v=hKq6RbxJHBo"
        ),
        .init(
            id: "74247e48-e299-4be5-a0ab-537f29fbc043",
            name: "Strawberries Romanoff",
            cuisine: "Russian",
            source: "https://natashaskitchen.com/strawberries-romanoff-recipe/",
            youTube: "https://www.youtube.com/watch?v=ybWHc4Vi-xU"
        ),
        .init(
            id: "d2251700-21da-4931-9dc6-4d273643f5c7",
            name: "Strawberry Rhubarb Pie",
            cuisine: "British",
            source: "https://www.joyofbaking.com/StrawberryRhubarbPie.html",
            youTube: "https://www.youtube.com/watch?v=tGw5Pwm4YA0"
        ),
        .init(
            id: "9f5a753e-472d-413e-a05b-ffbc8032e64c",
            name: "Sugar Pie",
            cuisine: "Canadian",
            source: "http://allrecipes.com/recipe/213595/miraculous-canadian-sugar-pie/",
            youTube: "https://www.youtube.com/watch?v=uVQ66jiL-Dc"
        ),
        .init(
            id: "9dd84450-9922-463a-bece-64f32f7a7dc5",
            name: "Summer Pudding",
            cuisine: "British",
            source: "https://www.bbcgoodfood.com/recipes/4516/summer-pudding",
            youTube: "https://www.youtube.com/watch?v=akJIO6UhXtA"
        ),
        .init(
            id: "744859ba-df52-4d56-b919-55fab43e8a45",
            name: "Tarte Tatin",
            cuisine: "French",
            source: "https://www.bbcgoodfood.com/recipes/tarte-tatin",
            youTube: "https://www.youtube.com/watch?v=8xDM8U6h9Pw"
        ),
        .init(
            id: "20e87ac3-e409-418c-a503-b466ab9b3752",
            name: "Timbits",
            cuisine: "Canadian",
            source: "http://www.geniuskitchen.com/recipe/drop-doughnuts-133877",
            youTube: "https://www.youtube.com/watch?v=fFLn1h80AGQ"
        ),
        .init(
            id: "55dcfb29-fe1b-4c28-8d0b-361497ae27f7",
            name: "Treacle Tart",
            cuisine: "British",
            source: "https://www.bbc.co.uk/food/recipes/mary_berrys_treacle_tart_28524",
            youTube: "https://www.youtube.com/watch?v=YMmgKCNcqwI"
        ),
        .init(
            id: "a1bedde3-2bc6-46f9-ab3c-0d98a2b11b64",
            name: "Tunisian Orange Cake",
            cuisine: "Tunisian",
            source: "http://allrecipes.co.uk/recipe/16067/tunisian-orange-cake.aspx",
            youTube: "https://www.youtube.com/watch?v=rCUxg866Ea4"
        ),
        .init(
            id: "7d6a2c69-f0ef-459a-abf5-c2e90b6555ff",
            name: "Walnut Roll Gužvara",
            cuisine: "Croatian",
            source: "https://www.visit-croatia.co.uk/croatian-cuisine/croatian-recipes/",
            youTube: "https://www.youtube.com/watch?v=Q_akngSJVrQ"
        ),
        .init(
            id: "ef7d81b7-07ba-4fab-a791-ae10e2817e66",
            name: "White Chocolate Crème Brûlée",
            cuisine: "French",
            source: "https://www.bbcgoodfood.com/recipes/2540/white-chocolate-crme-brle",
            youTube: "https://www.youtube.com/watch?v=LmJ0lsPLHDc"
        ),
    ])
}
