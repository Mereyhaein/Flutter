# Practice 11 — A Real Server

## Level 1 — API Exploration with curl

Date: November 19, 2026

Tool: curl (Mac terminal)

API: https://jsonplaceholder.typicode.com

### 1. GET /users

- HTTP Status: 200 OK
- Content-Type: application/json; charset=utf-8
- Number of users: 10
- Response format: JSON array

Result: Successfully received a list of 10 users from the server.

### 2. GET /users/1

- HTTP Status: 200 OK
- Response format: JSON object
- User ID: 1
- Name: Leanne Graham
- Username: Bret
- Email: Sincere@april.biz
- Nested objects: address and company
- Nested object inside address: geo

Result: Successfully received one user with complete information.

### 3. GET /users/999

- HTTP Status: 404 Not Found
- Response body: `{}`

Result: The requested user was not found.

### 4. GET /users?id=3

- HTTP Status: 200 OK
- Response format: JSON array
- Number of users returned: 1
- User ID: 3
- Name: Clementine Bauch

Result: Filtering by ID returned an array with one user, not a single JSON object.

### 5. POST /users

**Request body:**

```json
{
  "name": "Test Student",
  "username": "teststudent",
  "email": "test@example.com"
}
```

- HTTP Status: 201 Created
- Content-Type: application/json; charset=utf-8
- Server-assigned ID: 11

Result: The server returned the submitted fields and added `id: 11`. JSONPlaceholder simulates creation without permanent storage.

---

## JSON Field Analysis

### User — Top-Level Fields

| Field | JSON Type | Dart Type | Nullable in Model? |
|---|---|---|---|
| id | number (integer) | int | No |
| name | string | String | No |
| username | string | String | No |
| email | string | String | No |
| address | object | Address | No |
| phone | string | String | No |
| website | string | String? | Yes |
| company | object | Record | No |

All top-level fields were present in the observed GET response. Website is treated as nullable according to the lab requirements.

### Address Fields

| Field | JSON Type | Dart Type | Nullable? |
|---|---|---|---|
| street | string | String | No |
| suite | string | String | No |
| city | string | String | No |
| zipcode | string | String | No |
| geo | object | Geo | No |

### Geo Fields

| Field | JSON Type | Dart Type | Nullable? |
|---|---|---|---|
| lat | string | double | No |
| lng | string | double | No |

Latitude and longitude are strings in JSON. They must be converted using `double.parse()`.

### Company Fields

| Field | JSON Type | Dart Type | Nullable? |
|---|---|---|---|
| name | string | String | No |
| catchPhrase | string | String | No |
| bs | string | String | No |

The server returns all three company fields. The lab's specified company record uses name and catchPhrase.

---

## Level 1 Conclusion

I used curl to test GET and POST requests against the real JSONPlaceholder API. I examined HTTP status codes, JSON arrays, nested objects, and field types. All five required API requests were completed successfully.

## Level 5 — Network Testing

Airplane mode timing: Not tested yet.

Wi-Fi without internet timing: Not tested yet.

DevTools screenshots: Not captured yet.

The earlier curl connection problems are separate from the required Flutter application network tests.