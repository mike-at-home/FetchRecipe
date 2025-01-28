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

        public var flag: String? {
            switch self {
            case let .known(value): return value.flag
            case .unknown: return nil
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
    static let testList: Self = .init(recipes: [
        .init(
            id: "599344f4-3c5c-4cca-b914-2210e3b3312f",
            name: "Apple & Blackberry Crumble",
            cuisine: "British",
            source: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
            youTube: "https://www.youtube.com/watch?v=4vhcOwVBDO4"
        ),
        .init(
            id: "74f6d4eb-da50-4901-94d1-deae2d8af1d1",
            name: "Apple Frangipan Tart",
            cuisine: "British",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/large.jpg",
            youTube: "https://www.youtube.com/watch?v=rp8Slv4INLk"
        ),
        .init(
            id: "eed6005f-f8c8-451f-98d0-4088e2b40eb6",
            name: "Bakewell Tart",
            cuisine: "British",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/dd936646-8100-4a1c-b5ce-5f97adf30a42/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/dd936646-8100-4a1c-b5ce-5f97adf30a42/large.jpg",
            youTube: "https://www.youtube.com/watch?v=1ahpSTf_Pvk"
        ),
        .init(
            id: "f8b20884-1e54-4e72-a417-dabbc8d91f12",
            name: "Banana Pancakes",
            cuisine: "American",
            source: "https://www.bbcgoodfood.com/recipes/banana-pancakes",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/large.jpg",
            youTube: "https://www.youtube.com/watch?v=kSKtb2Sv-_U"
        ),
        .init(
            id: "891a474e-91cd-4996-865e-02ac5facafe3",
            name: "Battenberg Cake",
            cuisine: "British",
            source: "https://www.bbcgoodfood.com/recipes/1120657/battenberg-cake",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ec1b84b1-2729-4547-99db-5e0b625c0356/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ec1b84b1-2729-4547-99db-5e0b625c0356/large.jpg",
            youTube: "https://www.youtube.com/watch?v=aB41Q7kDZQ0"
        ),
        .init(
            id: "b5db2c09-411e-4bdf-9a75-a194dcde311b",
            name: "BeaverTails",
            cuisine: "Canadian",
            source: "https://www.tastemade.com/videos/beavertails",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/3b33a385-3e55-4ea5-9d98-13e78f840299/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/3b33a385-3e55-4ea5-9d98-13e78f840299/large.jpg",
            youTube: "https://www.youtube.com/watch?v=2G07UOqU2e8"
        ),
        .init(
            id: "8938f16a-954c-4d65-953f-fa069f3f1b0d",
            name: "Blackberry Fool",
            cuisine: "British",
            source: "https://www.bbc.co.uk/food/recipes/blackberry_fool_with_11859",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ff52841a-df5b-498c-b2ae-1d2e09ea658d/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ff52841a-df5b-498c-b2ae-1d2e09ea658d/large.jpg",
            youTube: "https://www.youtube.com/watch?v=kniRGjDLFrQ"
        ),
        .init(
            id: "02a80f95-09d6-430c-a9da-332584229d6f",
            name: "Bread and Butter Pudding",
            cuisine: "British",
            source: "https://cooking.nytimes.com/recipes/1018529-coq-au-vin",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/10818213-3c03-47ae-a7b1-230baa981226/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/10818213-3c03-47ae-a7b1-230baa981226/large.jpg",
            youTube: "https://www.youtube.com/watch?v=Vz5W1-BmOE4"
        ),
        .init(
            id: "563dbb27-5323-443c-b30c-c221ae598568",
            name: "Budino Di Ricotta",
            cuisine: "Italian",
            source: "https://thehappyfoodie.co.uk/recipes/ricotta-cake-budino-di-ricotta",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/2cac06b3-002e-4df7-bb08-e15bbc7e552d/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/2cac06b3-002e-4df7-bb08-e15bbc7e552d/large.jpg",
            youTube: "https://www.youtube.com/watch?v=6dzd6Ra6sb4"
        ),
        .init(
            id: "39ad8233-c470-4394-b65f-2a6c3218b935",
            name: "Canadian Butter Tarts",
            cuisine: "Canadian",
            source: "https://www.bbcgoodfood.com/recipes/1837/canadian-butter-tarts",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/f18384e7-3da7-4714-8f09-bbfa0d2c8913/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/f18384e7-3da7-4714-8f09-bbfa0d2c8913/large.jpg",
            youTube: "https://www.youtube.com/watch?v=WUpaOGghOdo"
        ),
        .init(
            id: "7e529e52-f56d-49a2-938f-81aac853cc65",
            name: "Carrot Cake",
            cuisine: "British",
            source: "https://www.bbc.co.uk/food/recipes/classic_carrot_cake_08513",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/32afc698-d927-4a90-990f-ec25e9520c08/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/32afc698-d927-4a90-990f-ec25e9520c08/large.jpg",
            youTube: "https://www.youtube.com/watch?v=asjZ7iTrGKA"
        ),
        .init(
            id: "7eeb0865-b41c-4a3b-80dd-a69d32dccc7d",
            name: "Cashew Ghoriba Biscuits",
            cuisine: "Tunisian",
            source: "http://allrecipes.co.uk/recipe/40152/cashew-ghoriba-biscuits.aspx",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/9c7fa988-1bbe-4bed-9f1a-c9d4d8b311da/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/9c7fa988-1bbe-4bed-9f1a-c9d4d8b311da/large.jpg",
            youTube: "https://www.youtube.com/watch?v=IqXEZUk4hWI"
        ),
        .init(
            id: "7fc217a9-5566-4bf1-b1ce-13bc9e3f2b1a",
            name: "Chelsea Buns",
            cuisine: "British",
            source: "https://www.bbc.co.uk/food/recipes/chelsea_buns_95015",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/4aecd46e-e419-49ec-8888-246b3cc0cc94/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/4aecd46e-e419-49ec-8888-246b3cc0cc94/large.jpg",
            youTube: "https://www.youtube.com/watch?v=i_zemP3yBKw"
        ),
        .init(
            id: "6377de22-4ec2-44c4-9e76-260be2e4fd90",
            name: "Chinon Apple Tarts",
            cuisine: "French",
            source: "https://www.bbcgoodfood.com/recipes/chinon-apple-tarts",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ec155176-ebb3-4e83-a320-c5c1d8d0c559/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ec155176-ebb3-4e83-a320-c5c1d8d0c559/large.jpg",
            youTube: "https://www.youtube.com/watch?v=5dAW9HQgtCk"
        ),
        .init(
            id: "6a3f96c1-02db-412a-ab7c-bb69b1bb4a8a",
            name: "Choc Chip Pecan Pie",
            cuisine: "American",
            source: "https://www.bbcgoodfood.com/recipes/choc-chip-pecan-pie",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/54462bd7-afc2-43aa-a10e-3ddd0a829954/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/54462bd7-afc2-43aa-a10e-3ddd0a829954/large.jpg",
            youTube: "https://www.youtube.com/watch?v=fDpoT0jvg4Y"
        ),
        .init(
            id: "b07b8b92-64c9-4322-ab15-e628a1b8fcbc",
            name: "Chocolate Avocado Mousse",
            cuisine: "British",
            source: "http://www.hemsleyandhemsley.com/recipe/chocolate-avocado-mousse/",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/27c50c00-148e-4d2a-abb7-942182bb6d94/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/27c50c00-148e-4d2a-abb7-942182bb6d94/large.jpg",
            youTube: "https://www.youtube.com/watch?v=wuZffe60q4M"
        ),
        .init(
            id: "1bf34a8c-4579-479f-91e0-6eed354f6b2c",
            name: "Chocolate Caramel Crispy",
            cuisine: "British",
            source: "http://www.donalskehan.com/recipes/chocolate-caramel-rice-crispy-treats/",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/1c1616f6-81d2-447d-a1ae-51352edfde0c/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/1c1616f6-81d2-447d-a1ae-51352edfde0c/large.jpg",
            youTube: "https://www.youtube.com/watch?v=qsk_At_gjv0"
        ),
        .init(
            id: "7e9fc2d3-9759-46ee-976e-d6ca0f682091",
            name: "Chocolate Gateau",
            cuisine: "French",
            source: "http://www.goodtoknow.co.uk/recipes/536028/chocolate-gateau",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/bfc6bc1d-3e24-4f9e-a496-bd4f3f002539/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/bfc6bc1d-3e24-4f9e-a496-bd4f3f002539/large.jpg",
            youTube: "https://www.youtube.com/watch?v=dsJtgmAhFF4"
        ),
        .init(
            id: "606f22ce-fcd1-434e-a6da-9571c0b2fc9b",
            name: "Chocolate Raspberry Brownies",
            cuisine: "American",
            source: "https://www.bbcgoodfood.com/recipes/2121648/bestever-chocolate-raspberry-brownies",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/74aa9345-00ae-4178-9aa7-8fcee19af160/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/74aa9345-00ae-4178-9aa7-8fcee19af160/large.jpg",
            youTube: "https://www.youtube.com/watch?v=Pi89PqsAaAg"
        ),
        .init(
            id: "003cd03a-6e93-48ba-aa3d-0f53f40569ad",
            name: "Chocolate Souffle",
            cuisine: "French",
            source: "https://www.bbcgoodfood.com/recipes/5816/hot-chocolate-souffls-with-chocolate-cream-sauce",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/76c7f8a1-9676-4cba-be3e-91bd53592d27/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/76c7f8a1-9676-4cba-be3e-91bd53592d27/large.jpg",
            youTube: "https://www.youtube.com/watch?v=FWqfkUEWOTg"
        ),
        .init(
            id: "a4139f76-e677-4092-ba69-5d4c5134d9d8",
            name: "Christmas Pudding Flapjack",
            cuisine: "British",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ed302719-f455-4109-948d-839f690a9ea8/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ed302719-f455-4109-948d-839f690a9ea8/large.jpg",
            youTube: "https://www.youtube.com/watch?v=OaqvGvEiwzU"
        ),
        .init(
            id: "e48c39c5-793d-491a-9c29-9417dc5e7e1c",
            name: "Christmas Pudding Trifle",
            cuisine: "British",
            source: "https://www.bbcgoodfood.com/recipes/1826685/christmas-pudding-trifle",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/f59ddd71-4730-4531-bbec-3d382e3b2175/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/f59ddd71-4730-4531-bbec-3d382e3b2175/large.jpg",
            youTube: "https://www.youtube.com/watch?v=jRfyNQs5qhU"
        ),
        .init(
            id: "088ac6dc-9804-483d-aa2e-845263daf90a",
            name: "Christmas Cake",
            cuisine: "British",
            source: "https://www.bbcgoodfood.com/recipes/angela-nilsens-christmas-cake",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/aaa5dab0-febe-4fc4-800d-36e293764f98/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/aaa5dab0-febe-4fc4-800d-36e293764f98/large.jpg",
            youTube: "https://www.youtube.com/watch?v=34yeL8TstO0"
        ),
        .init(
            id: "d603f36e-7aae-4a51-a96a-6711f582de19",
            name: "Classic Christmas Pudding",
            cuisine: "British",
            source: "https://www.bbcgoodfood.com/recipes/classic-christmas-pudding",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/604d020a-967a-40e1-97d2-561de5c66807/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/604d020a-967a-40e1-97d2-561de5c66807/large.jpg",
            youTube: "https://www.youtube.com/watch?v=Pb_lJxL1vtk"
        ),
        .init(
            id: "6b628dfc-5473-4924-b80c-5718cdae8b2a",
            name: "Dundee Cake",
            cuisine: "British",
            source: "https://www.bbcgoodfood.com/recipes/2155640/dundee-cake",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/8bf9399d-c42c-4316-8a3b-5dfce59d986b/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/8bf9399d-c42c-4316-8a3b-5dfce59d986b/large.jpg",
            youTube: "https://www.youtube.com/watch?v=4hEXsfpeMQE"
        ),
        .init(
            id: "265454f1-d1a6-470c-bc20-1d9ba73c8073",
            name: "Eccles Cakes",
            cuisine: "British",
            source: "https://www.bbcgoodfood.com/recipes/786659/eccles-cakes",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/a6c39bad-bc6a-41c6-8588-2c97327a46cd/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/a6c39bad-bc6a-41c6-8588-2c97327a46cd/large.jpg",
            youTube: "https://www.youtube.com/watch?v=xV0QCJ0GD5w"
        ),
        .init(
            id: "1a86ef7d-a9f1-44c1-a4a0-2278f5916d49",
            name: "Eton Mess",
            cuisine: "British",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/258262f1-57dc-4895-8856-bf95aee43054/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/258262f1-57dc-4895-8856-bf95aee43054/large.jpg",
            youTube: "https://www.youtube.com/watch?v=43WgiNq54L8"
        ),
        .init(
            id: "98c27533-a823-426d-8639-a2b334ec659a",
            name: "Honey Yogurt Cheesecake",
            cuisine: "Greek",
            source: "https://www.bbcgoodfood.com/recipes/honey-yogurt-cheesecake",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/70785def-8f3c-4bc6-b5bd-77053fa8d701/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/70785def-8f3c-4bc6-b5bd-77053fa8d701/large.jpg",
            youTube: "https://www.youtube.com/watch?v=JE8crtueXs8"
        ),
        .init(
            id: "a43f53ea-4d06-46c1-bd20-5d8e487ea52b",
            name: "Hot Chocolate Fudge",
            cuisine: "American",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/6d8e878b-0ca8-4173-94b7-60a006b676d6/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/6d8e878b-0ca8-4173-94b7-60a006b676d6/large.jpg",
            youTube: "https://www.youtube.com/watch?v=oJvbsVSblfk"
        ),
        .init(
            id: "338c1c7b-656a-4166-8a17-a7f99c6119e2",
            name: "Jam Roly-Poly",
            cuisine: "British",
            source: "https://www.bbcgoodfood.com/recipes/13354/jam-rolypoly",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/5460345d-4057-4ffe-a4ee-0ba9a8b91ed6/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/5460345d-4057-4ffe-a4ee-0ba9a8b91ed6/large.jpg",
            youTube: "https://www.youtube.com/watch?v=5ZYWVQ8imVA"
        ),
        .init(
            id: "303ce395-af37-4cff-87b4-09c75a4e07ed",
            name: "Key Lime Pie",
            cuisine: "American",
            source: "https://www.bbcgoodfood.com/recipes/2155644/key-lime-pie",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/d23ad009-8f17-428f-a41f-5f3b5bc51883/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/d23ad009-8f17-428f-a41f-5f3b5bc51883/large.jpg",
            youTube: "https://www.youtube.com/watch?v=q4Rz7tUkX9A"
        ),
        .init(
            id: "9e230f96-f93d-4d29-9230-a1f5fd539464",
            name: "Krispy Kreme Donut",
            cuisine: "American",
            source: "https://www.mythirtyspot.com/krispy-kreme-copycat-recipe-for/",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/def8c76f-9054-40ff-8021-7f39148ad4b7/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/def8c76f-9054-40ff-8021-7f39148ad4b7/large.jpg",
            youTube: "https://www.youtube.com/watch?v=SamYg6IUGOI"
        ),
        .init(
            id: "36cf73a3-c505-4a68-b11a-977b2a02d83d",
            name: "Mince Pies",
            cuisine: "British",
            source: "https://www.bbcgoodfood.com/recipes/2174/unbelievably-easy-mince-pies",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/8f69452d-d1af-4a5c-9461-203611502b30/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/8f69452d-d1af-4a5c-9461-203611502b30/large.jpg",
            youTube: "https://www.youtube.com/watch?v=PnXft7lQNJE"
        ),
        .init(
            id: "19c33de0-c9ab-4692-b484-4d9c803b9424",
            name: "Nanaimo Bars",
            cuisine: "Canadian",
            source: "https://www.bbcgoodfood.com/recipes/nanaimo-bars",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/67257b12-6702-4a9b-b0db-65bd4cbbb6b4/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/67257b12-6702-4a9b-b0db-65bd4cbbb6b4/large.jpg",
            youTube: "https://www.youtube.com/watch?v=MMrE4I1ZtWo"
        ),
        .init(
            id: "b63fbae1-f5d1-41a7-a030-1a3a556f4c57",
            name: "New York Cheesecake",
            cuisine: "American",
            source: "https://www.bbcgoodfood.com/recipes/2869/new-york-cheesecake",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/9d257442-51c8-45c7-807a-e6132baa8fce/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/9d257442-51c8-45c7-807a-e6132baa8fce/large.jpg",
            youTube: "https://www.youtube.com/watch?v=tspdJ6hxqnc"
        ),
        .init(
            id: "fa4ad799-0706-4146-95a7-09f24b6dd1da",
            name: "Pancakes",
            cuisine: "American",
            source: "https://www.bbcgoodfood.com/recipes/2907669/easy-pancakes",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b2879d3a-b145-4618-9c1d-fd3a451d0739/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b2879d3a-b145-4618-9c1d-fd3a451d0739/large.jpg",
            youTube: "https://www.youtube.com/watch?v=LWuuCndtJr0"
        ),
        .init(
            id: "5de59157-f84b-4390-b8f4-ff19104782da",
            name: "Parkin Cake",
            cuisine: "British",
            source: "https://www.bbcgoodfood.com/recipes/1940684/parkin",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/f860d6d3-fc18-4c41-b368-2c86a44b79b8/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/f860d6d3-fc18-4c41-b368-2c86a44b79b8/large.jpg",
            youTube: "https://www.youtube.com/watch?v=k1lG4vk2MQA"
        ),
        .init(
            id: "cf8cbc60-2fce-4af8-8317-1736e9e116d1",
            name: "Peach & Blueberry Grunt",
            cuisine: "American",
            source: "https://www.bbcgoodfood.com/recipes/1553651/peach-and-blueberry-grunt",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/483a686e-8f97-4139-b575-1c154d542b10/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/483a686e-8f97-4139-b575-1c154d542b10/large.jpg",
            youTube: "https://www.youtube.com/watch?v=SNeO28BCpsc"
        ),
        .init(
            id: "ba8e2e4e-e1b3-4231-a663-eef155fabbdc",
            name: "Peanut Butter Cheesecake",
            cuisine: "American",
            source: "https://www.bbcgoodfood.com/recipes/1759649/peanut-butter-cheesecake",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b65a6b5c-fcbd-46bc-b87e-cd69a9f8e656/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b65a6b5c-fcbd-46bc-b87e-cd69a9f8e656/large.jpg",
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
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/376f3377-c481-43cf-bcc6-c0befd612552/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/376f3377-c481-43cf-bcc6-c0befd612552/large.jpg",
            youTube: "https://www.youtube.com/watch?v=8U1tKWKDeWA"
        ),
        .init(
            id: "25a52168-29f8-4309-b48b-a96cae6ce867",
            name: "Polskie NaleÅ›niki (Polish Pancakes)",
            cuisine: "Polish",
            source: "https://www.tasteatlas.com/nalesniki/recipe",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/8b526c42-5121-4ddf-b8f9-a0c1153b5c20/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/8b526c42-5121-4ddf-b8f9-a0c1153b5c20/large.jpg",
            youTube: "https://www.youtube.com/watch?v=EZS4ev2crHc"
        ),
        .init(
            id: "630dec20-76a5-468b-9bd9-bfd170515204",
            name: "Portuguese Custard Tarts",
            cuisine: "Portuguese",
            source: "https://www.olivemagazine.com/recipes/baking-and-desserts/portuguese-custard-tarts/",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/759e00ff-20fc-45c4-ae78-404280e84970/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/759e00ff-20fc-45c4-ae78-404280e84970/large.jpg",
            youTube: "https://www.youtube.com/watch?v=lWLCxui1Mw8"
        ),
        .init(
            id: "11b2e8a4-7f4e-4b81-b8db-09ea2f10e9d3",
            name: "Pumpkin Pie",
            cuisine: "American",
            source: "https://www.bbcgoodfood.com/recipes/1742633/pumpkin-pie",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/93e50ff1-bf1d-4f88-8978-e18e01d3231d/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/93e50ff1-bf1d-4f88-8978-e18e01d3231d/large.jpg",
            youTube: "https://www.youtube.com/watch?v=hpapqEeb36k"
        ),
        .init(
            id: "cdc34bb5-c9e3-4465-9088-cf2e2aa8e4ee",
            name: "Rock Cakes",
            cuisine: "British",
            source: "https://www.bbc.co.uk/food/recipes/rock_cakes_03094",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/dce36ed7-d5bd-4532-9e9f-fafd75a4eb8f/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/dce36ed7-d5bd-4532-9e9f-fafd75a4eb8f/large.jpg",
            youTube: "https://www.youtube.com/watch?v=tY3taZO3Aro"
        ),
        .init(
            id: "fe81ba97-ee9e-4af9-bc3a-4f7a86eeb820",
            name: "Rocky Road Fudge",
            cuisine: "American",
            source: "http://tiphero.com/rocky-road-fudge/",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b51b389c-a408-4664-b0d2-a437cbc352b0/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b51b389c-a408-4664-b0d2-a437cbc352b0/large.jpg",
            youTube: "https://www.youtube.com/watch?v=N1aJ3nEYXyg"
        ),
        .init(
            id: "e084dc2c-37e7-4600-9b46-76e673e8e2d2",
            name: "Rogaliki (Polish Croissant Cookies)",
            cuisine: "Polish",
            source: "https://www.food.com/recipe/rogaliki-polish-croissant-cookies-with-jam-filling-200668",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/15d50359-5f62-4583-a9e9-d761bc58fecf/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/15d50359-5f62-4583-a9e9-d761bc58fecf/large.jpg",
            youTube: "https://www.youtube.com/watch?v=VAR10T9mfhU"
        ),
        .init(
            id: "23fb89ed-00ec-407e-8802-d0a510973df9",
            name: "Salted Caramel Cheescake",
            cuisine: "American",
            source: "http://www.janespatisserie.com/2015/11/09/no-bake-salted-caramel-cheesecake/",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b75ee8ef-a290-4062-8b26-60722d75d09c/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b75ee8ef-a290-4062-8b26-60722d75d09c/large.jpg",
            youTube: "https://www.youtube.com/watch?v=q5dQp3qpmI4"
        ),
        .init(
            id: "c4560eaa-3c0f-4266-beba-4ddce62063e0",
            name: "Seri Muka Kuih",
            cuisine: "Malaysian",
            source: "https://makan.ch/recipe/kuih-seri-muka/",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/658442fe-e3d3-44a5-9081-e2424fb0129d/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/658442fe-e3d3-44a5-9081-e2424fb0129d/large.jpg",
            youTube: "https://www.youtube.com/watch?v=_NJtCfqgaBo"
        ),
        .init(
            id: "2b9003b5-000d-445a-8b19-bbaed1b9f851",
            name: "Spotted Dick",
            cuisine: "British",
            source: "https://www.bbcgoodfood.com/recipes/2686661/spotted-dick",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/1990117c-dcb1-41aa-bdaf-562b23bdf3d0/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/1990117c-dcb1-41aa-bdaf-562b23bdf3d0/large.jpg",
            youTube: "https://www.youtube.com/watch?v=fu15XOF-ros"
        ),
        .init(
            id: "ee112b29-829b-45c6-8c3d-3effe739c9f0",
            name: "Sticky Toffee Pudding",
            cuisine: "British",
            source: "https://www.bbc.co.uk/food/recipes/marys_sticky_toffee_41970",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/d9e32cfd-818d-4428-8f49-b3a6ae624f58/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/d9e32cfd-818d-4428-8f49-b3a6ae624f58/large.jpg",
            youTube: "https://www.youtube.com/watch?v=Wytv3bjqJII"
        ),
        .init(
            id: "7365af2d-ab0b-4bab-a94f-462ffd752a09",
            name: "Sticky Toffee Pudding Ultimate",
            cuisine: "British",
            source: "https://www.youtube.com/watch?v=Wytv3bjqJII",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/f21f80c8-890a-46c5-8d1e-28baf52c30c8/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/f21f80c8-890a-46c5-8d1e-28baf52c30c8/large.jpg",
            youTube: "https://www.youtube.com/watch?v=hKq6RbxJHBo"
        ),
        .init(
            id: "74247e48-e299-4be5-a0ab-537f29fbc043",
            name: "Strawberries Romanoff",
            cuisine: "Russian",
            source: "https://natashaskitchen.com/strawberries-romanoff-recipe/",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/3e79a729-35d0-4043-abe1-9e258be7e8c2/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/3e79a729-35d0-4043-abe1-9e258be7e8c2/large.jpg",
            youTube: "https://www.youtube.com/watch?v=ybWHc4Vi-xU"
        ),
        .init(
            id: "d2251700-21da-4931-9dc6-4d273643f5c7",
            name: "Strawberry Rhubarb Pie",
            cuisine: "British",
            source: "https://www.joyofbaking.com/StrawberryRhubarbPie.html",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/74cf131b-c541-4871-bed7-588a1f369c7d/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/74cf131b-c541-4871-bed7-588a1f369c7d/large.jpg",
            youTube: "https://www.youtube.com/watch?v=tGw5Pwm4YA0"
        ),
        .init(
            id: "9f5a753e-472d-413e-a05b-ffbc8032e64c",
            name: "Sugar Pie",
            cuisine: "Canadian",
            source: "http://allrecipes.com/recipe/213595/miraculous-canadian-sugar-pie/",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/25624a61-cf25-4e26-8a3a-b38f347e3642/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/25624a61-cf25-4e26-8a3a-b38f347e3642/large.jpg",
            youTube: "https://www.youtube.com/watch?v=uVQ66jiL-Dc"
        ),
        .init(
            id: "9dd84450-9922-463a-bece-64f32f7a7dc5",
            name: "Summer Pudding",
            cuisine: "British",
            source: "https://www.bbcgoodfood.com/recipes/4516/summer-pudding",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/d7f2d753-a434-426b-afdd-c63b899bcac1/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/d7f2d753-a434-426b-afdd-c63b899bcac1/large.jpg",
            youTube: "https://www.youtube.com/watch?v=akJIO6UhXtA"
        ),
        .init(
            id: "744859ba-df52-4d56-b919-55fab43e8a45",
            name: "Tarte Tatin",
            cuisine: "French",
            source: "https://www.bbcgoodfood.com/recipes/tarte-tatin",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/51271127-2c5f-4b65-87d4-f56f8f9a9549/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/51271127-2c5f-4b65-87d4-f56f8f9a9549/large.jpg",
            youTube: "https://www.youtube.com/watch?v=8xDM8U6h9Pw"
        ),
        .init(
            id: "20e87ac3-e409-418c-a503-b466ab9b3752",
            name: "Timbits",
            cuisine: "Canadian",
            source: "http://www.geniuskitchen.com/recipe/drop-doughnuts-133877",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7f6a259a-71df-42c2-b314-065e0c736c67/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7f6a259a-71df-42c2-b314-065e0c736c67/large.jpg",
            youTube: "https://www.youtube.com/watch?v=fFLn1h80AGQ"
        ),
        .init(
            id: "55dcfb29-fe1b-4c28-8d0b-361497ae27f7",
            name: "Treacle Tart",
            cuisine: "British",
            source: "https://www.bbc.co.uk/food/recipes/mary_berrys_treacle_tart_28524",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/dac510db-fa7f-4bf1-af61-706a9c960455/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/dac510db-fa7f-4bf1-af61-706a9c960455/large.jpg",
            youTube: "https://www.youtube.com/watch?v=YMmgKCNcqwI"
        ),
        .init(
            id: "a1bedde3-2bc6-46f9-ab3c-0d98a2b11b64",
            name: "Tunisian Orange Cake",
            cuisine: "Tunisian",
            source: "http://allrecipes.co.uk/recipe/16067/tunisian-orange-cake.aspx",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/903015fb-7bc2-426b-aa1b-724d0007ce30/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/903015fb-7bc2-426b-aa1b-724d0007ce30/large.jpg",
            youTube: "https://www.youtube.com/watch?v=rCUxg866Ea4"
        ),
        .init(
            id: "7d6a2c69-f0ef-459a-abf5-c2e90b6555ff",
            name: "Walnut Roll Gužvara",
            cuisine: "Croatian",
            source: "https://www.visit-croatia.co.uk/croatian-cuisine/croatian-recipes/",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/8f60cd87-20ab-419b-a425-56b7ad7c8566/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/8f60cd87-20ab-419b-a425-56b7ad7c8566/large.jpg",
            youTube: "https://www.youtube.com/watch?v=Q_akngSJVrQ"
        ),
        .init(
            id: "ef7d81b7-07ba-4fab-a791-ae10e2817e66",
            name: "White Chocolate Crème Brûlée",
            cuisine: "French",
            source: "https://www.bbcgoodfood.com/recipes/2540/white-chocolate-crme-brle",
            smallPhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/f4b7b7d7-9671-410e-bf81-39a007ede535/small.jpg",
            largePhoto: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/f4b7b7d7-9671-410e-bf81-39a007ede535/large.jpg",
            youTube: "https://www.youtube.com/watch?v=LmJ0lsPLHDc"
        ),
    ])
}
