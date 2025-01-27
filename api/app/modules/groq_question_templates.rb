# frozen_string_literal: true

module GroqQuestionTemplates
  TEMPLATES = {
    find_receipt_by_ingredients: 'app/templates/groq_question_templates/find_receipt_by_ingredients.txt.erb',
    confirm_text_is_real_recipe: 'app/templates/groq_question_templates/confirm_text_is_real_recipe.txt.erb'
  }.freeze

  module_function

  # @param ingredients [Array<String>]
  # @return [String]
  def find_receipt_by_ingredients(ingredients:)
    template_path = TEMPLATES[:find_receipt_by_ingredients]
    render_template(template_path, ingredients: ingredients)
  end

  # @param probable_recipe_text [String]
  # @return [String]
  def confirm_text_is_real_recipe(probable_recipe_text:)
    template_path = TEMPLATES[:confirm_text_is_real_recipe]
    render_template(template_path, probable_recipe_text: probable_recipe_text)
  end

  def render_template(template_path, **args)
    Tilt.new(template_path).render(self, **args)
  end
end
