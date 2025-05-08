from flask import Flask, request, jsonify
from flask_session import Session  # Для хранения сессий
import secrets
from apiclient import Client

app = Flask(__name__)
app.config['SECRET_KEY'] = secrets.token_hex(32)
app.config['SESSION_TYPE'] = 'filesystem'
Session(app)

# Словарь для хранения клиентов (вместо глобальной переменной)
active_clients = {}  # {session_id: Client}

@app.route('/api/init_session', methods=['POST'])
def init():
    data = request.json
    session_id = secrets.token_hex(16)  # Генерируем уникальный ID сессии
    
    # Создаем новый экземпляр Client для этого пользователя
    active_clients[session_id] = Client(
        host=data['host'],
        auth=data['auth'],
        username=data['username'],
        password=data['password'],
        verify_certificate=data.get('verify_certificate', False)
    )
    
    return jsonify({
        "status": "success",
        "session_id": session_id  # Возвращаем клиенту его session_id
    })

@app.route('/api/call_method', methods=['POST'])
def call_method():
    data = request.json
    session_id = data.get('session_id')
    
    if not session_id or session_id not in active_clients:
        return jsonify({"error": "Invalid or missing session_id"}), 401
        
    client = active_clients[session_id]
    
    try:
        method = getattr(client, data['method'])
        result = method(**data.get('args', {}))
        return jsonify({"status": "success", "result": result})
    except Exception as e:
        return jsonify({"status": "error", "error": str(e)}), 500

@app.route('/api/logout', methods=['POST'])
def logout():
    session_id = request.json.get('session_id')
    if session_id in active_clients:
        del active_clients[session_id]
    return jsonify({"status": "success"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)