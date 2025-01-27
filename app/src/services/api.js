import { getValidToken } from './auth';

export const authenticatedFetch = async (url, options = {}) => {
  const token = await getValidToken();

  return fetch(url, {
    ...options,
    headers: {
      ...options.headers,
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json',
    },
  });
};
