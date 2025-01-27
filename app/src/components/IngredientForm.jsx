import { useState } from 'react';
import './IngredientForm.css';

function IngredientForm({ onSubmit }) {
  const [ingredients, setIngredients] = useState([]);
  const [currentInput, setCurrentInput] = useState('');

  const handleKeyDown = (e) => {
    if (e.key === 'Enter' && currentInput.trim()) {
      e.preventDefault();
      addIngredient();
    } else if (e.key === 'Backspace' && !currentInput) {
      removeIngredient(ingredients.length - 1);
    }
  };

  const addIngredient = () => {
    const ingredient = currentInput.trim().toLowerCase();
    if (ingredient && !ingredients.includes(ingredient)) {
      setIngredients([...ingredients, ingredient]);
      setCurrentInput('');
    }
  };

  const removeIngredient = (index) => {
    setIngredients(ingredients.filter((_, i) => i !== index));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (ingredients.length > 0) {
      onSubmit(ingredients);
    }
  };

  return (
    <div className="ingredient-form">
      <h2>Enter Your Ingredients</h2>
      <form onSubmit={handleSubmit}>
        <div className="ingredients-input">
          <div className="ingredients-tags">
            {ingredients.map((ingredient, index) => (
              <span key={index} className="ingredient-tag">
                {ingredient}
                <button
                  type="button"
                  onClick={() => removeIngredient(index)}
                  className="remove-tag"
                >
                  ×
                </button>
              </span>
            ))}
          </div>
          <input
            type="text"
            value={currentInput}
            onChange={(e) => setCurrentInput(e.target.value)}
            onKeyDown={handleKeyDown}
            placeholder="Enter ingredient"
            className="ingredient-input"
          />
        </div>
        <button
          type="submit"
          className="find-recipe-btn"
          disabled={ingredients.length === 0}
        >
          Find Recipe
        </button>
      </form>
    </div>
  );
}

export default IngredientForm;
