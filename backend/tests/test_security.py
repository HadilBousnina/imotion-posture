from app.core.security import (
    hash_password,
    verify_password,
    create_access_token,
    decode_access_token,
)

password = "azerty123"

hashed = hash_password(password)
print("Hash :", hashed)

print("Verify :", verify_password(password, hashed))

token = create_access_token({"sub": "coach@test.com"})
print("Token :", token)

payload = decode_access_token(token)
print("Payload :", payload)