from flask import Flask, request, jsonify
from flask_cors import CORS
from apiclient import Client

app = Flask(__name__)
CORS(app)

client = None

@app.route('/init', methods=['POST'])
def init():
    global client
    data = request.json
    client = Client(
        host=data['host'],
        auth=data['auth'],
        username=data['username'],
        password=data['password'],
        verify_certificate=data.get('verify_certificate', False)
    )
    return jsonify({"status": "success"})

@app.route('/call_method', methods=['POST'])
def call_method():
    global client
    if not client:
        return jsonify({"error": "Client not initialized"}), 400

    data = request.json
    method_name = data['method']
    args = data.get('args', {})  # args всегда должен быть словарем
    
    try:
        method = getattr(client, method_name)
        result = method(**args)  # Всегда передаем аргументы как kwargs
        return jsonify({"status": "success", "result": result})
    except Exception as e:
        return jsonify({"status": "error", "error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)