import { useState, useEffect } from 'react';
import IngredientForm from './components/IngredientForm';
import { getValidToken } from './services/auth';
import { createRecipeSearch, checkRecipeStatus, getRecipeAnswer } from './services/recipeSearch';
import './App.css';

function App() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [recipe, setRecipe] = useState(null);
  const [searchId, setSearchId] = useState(null);
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  useEffect(() => {
    const initAuth = async () => {
      try {
        await getValidToken();
        setIsAuthenticated(true);
      } catch (err) {
        setError('Failed to authenticate with API');
        console.error('Auth error:', err);
      }
    };

    initAuth();
  }, []);

  const handleSubmit = async (ingredients) => {
    setLoading(true);
    setError(null);

    try {
      const response = await createRecipeSearch(ingredients);
      setSearchId(response.id);
      pollStatus(response.id);
    } catch (err) {
      setError('Failed to submit ingredients. Please try again.');
      setLoading(false);
    }
  };

  const pollStatus = async (id) => {
    try {
      const { status } = await checkRecipeStatus(id);

      if (status === 'confirmed') {
        const answer = await getRecipeAnswer(id);
        setRecipe(answer);
        setLoading(false);
        return;
      }

      if (['search_error', 'confirmation_error', 'confirmation_failed'].includes(status)) {
        throw new Error('Recipe search failed');
      }

      setTimeout(() => pollStatus(id), 2000);

    } catch (err) {
      setError('Failed to get recipe. Please try again.');
      setLoading(false);
    }
  };

  if (!isAuthenticated) {
    return <div>Authenticating...</div>;
  }

  return (
    <div className="app">
      <h1>Recipe Finder</h1>
      {error && <div className="error-message">{error}</div>}
      <IngredientForm onSubmit={handleSubmit} />
      {loading && <div className="loading">Searching for recipes...</div>}
      {recipe && (
        <div className="recipe-result">
          <h2>Found Recipe:</h2>
          <pre>{recipe.answer}</pre>
        </div>
      )}
    </div>
  );
}

export default App;
