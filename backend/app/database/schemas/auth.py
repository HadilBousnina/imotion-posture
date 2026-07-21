from pydantic import BaseModel, EmailStr


class LoginRequest(BaseModel):
    """
    Données envoyées lors de la connexion.
    """

    email: EmailStr
    password: str


class Token(BaseModel):
    """
    Réponse renvoyée après une connexion réussie.
    """

    access_token: str
    token_type: str


class TokenData(BaseModel):
    """
    Informations extraites du JWT.
    """

    email: str | None = None