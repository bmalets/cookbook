import { RECIPE_SEARCH_ENDPOINT } from '../config/api';
import { authenticatedFetch } from './api';

export const createRecipeSearch = async (ingredients) => {
  const response = await authenticatedFetch(RECIPE_SEARCH_ENDPOINT, {
    method: 'POST',
    body: JSON.stringify({
      recipe_search: { ingredients }
    })
  });

  if (!response.ok) {
    throw new Error('Failed to create recipe search');
  }

  return response.json();
};

export const checkRecipeStatus = async (id) => {
  const response = await authenticatedFetch(`${RECIPE_SEARCH_ENDPOINT}/${id}/status`);

  if (!response.ok) {
    throw new Error('Failed to check recipe status');
  }

  return response.json();
};

export const getRecipeAnswer = async (id) => {
  const response = await authenticatedFetch(`${RECIPE_SEARCH_ENDPOINT}/${id}/answer`);

  if (!response.ok) {
    throw new Error('Failed to get recipe answer');
  }

  return response.json();
};
