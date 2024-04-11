//
//  RandomRecipeModel.swift
//  RecipeApp
//
//  Created by Simranjot Kaur on 2024-04-11.
//

import Foundation

class RandomRecipeModel : Codable {
    var title: String?
    var image: String?
    var sourceUrl: String?
    var servings: Int?
}

class RandomRecipeList {
    var randomRecipesList = [RandomRecipeModel]()
}

struct RandomRecipeResponse: Codable {
    let recipes: [RandomRecipeModel]?
}
