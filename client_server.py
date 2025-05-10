from flask import Flask, request, jsonify
from flask_cors import CORS  # Добавляем поддержку CORS
import secrets
from apiclient import Client

app = Flask(__name__)

# Настройка CORS (разрешаем запросы с любых доменов для разработки)
CORS(app, resources={
    r"/api/*": {
        "origins": ["*"],
        "methods": ["GET", "POST", "OPTIONS"],
        "allow_headers": ["Content-Type"]
    }
})

app.config['SECRET_KEY'] = secrets.token_hex(32)
active_clients = {}  # {session_id: Client}

@app.route('/api/init_session', methods=['POST', 'OPTIONS'])
def init():
    print(request)
    if request.method == 'OPTIONS':
        return _build_cors_preflight_response()
    
    data = request.json
    session_id = secrets.token_hex(16)
    
    active_clients[session_id] = Client(
        host=data['host'],
        auth=data['auth'],
        username=data['username'],
        password=data['password'],
        verify_certificate=data.get('verify_certificate', False)
    )
    
    return _corsify_response(jsonify({
        "status": "success",
        "session_id": session_id
    }))

@app.route('/api/call', methods=['POST', 'OPTIONS'])
def call_method():
    print(request)
    if request.method == 'OPTIONS':
        return _build_cors_preflight_response()
    
    data = request.json
    session_id = data.get('session_id')
    
    if not session_id or session_id not in active_clients:
        return _corsify_response(jsonify({"error": "Invalid or missing session_id"}), 401)
        
    client = active_clients[session_id]
    
    try:
        method = getattr(client, data['method'])
        result = method(**data.get('args', {}))
        return _corsify_response(jsonify({"status": "success", "result": result}))
    except Exception as e:
        return _corsify_response(jsonify({"status": "error", "error": str(e)}), 500)

@app.route('/api/logout', methods=['POST', 'OPTIONS'])
def logout():
    if request.method == 'OPTIONS':
        return _build_cors_preflight_response()
    
    session_id = request.json.get('session_id')
    if session_id in active_clients:
        del active_clients[session_id]
    return _corsify_response(jsonify({"status": "success"}))

# Вспомогательные функции для CORS
def _build_cors_preflight_response():
    response = jsonify({"message": "Preflight Accepted"})
    response.headers.add("Access-Control-Allow-Origin", "*")
    response.headers.add("Access-Control-Allow-Headers", "*")
    response.headers.add("Access-Control-Allow-Methods", "*")
    return response

def _corsify_response(response, status_code=None):
    if status_code:
        response.status_code = status_code
    response.headers.add("Access-Control-Allow-Origin", "*")
    return response

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8000, debug=True)