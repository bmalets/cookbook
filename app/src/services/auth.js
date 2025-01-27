import { TOKEN_ENDPOINT } from '../config/api';

const getClientCredentialsToken = async () => {
  try {
    const payload = {
      grant_type: 'client_credentials',
      scopes: ['read', 'write'],
      client_id: import.meta.env.VITE_CLIENT_ID,
      client_secret: import.meta.env.VITE_CLIENT_SECRET,
    };

    const response = await fetch(TOKEN_ENDPOINT, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload),
    });

    if (!response.ok) {
      const errorData = await response.json();
      console.error('Token error details:', errorData);
      throw new Error('Failed to get access token');
    }

    const data = await response.json();
    localStorage.setItem('access_token', data.access_token);
    localStorage.setItem('token_expiry', Date.now() + (data.expires_in * 1000));
    return data.access_token;
  } catch (error) {
    console.error('Error getting token:', error);
    throw error;
  }
};

export const getValidToken = async () => {
  const currentToken = localStorage.getItem('access_token');
  const tokenExpiry = localStorage.getItem('token_expiry');

  if (currentToken && tokenExpiry && Date.now() < parseInt(tokenExpiry)) {
    return currentToken;
  }

  return getClientCredentialsToken();
};
