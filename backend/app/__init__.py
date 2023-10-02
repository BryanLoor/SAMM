from flask import Flask, jsonify,request
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity
from flask_cors import cross_origin

from app.config import Config

def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)
    app.debug = True

    from app.extensions import db
    db.init_app(app)

    from app.extensions import ma
    ma.init_app(app)

    from app.extensions import cors
    cors.init_app(app,resources={r"/*": {"origins": "*", "headers":["Content-Type", "Authorization"]}})

    from app.extensions import jwt
    jwt.init_app(app)

    from app.login import bp as login_bp
    app.register_blueprint(login_bp, url_prefix='/login')


    from app.rutas import bp as rutas_bp
    app.register_blueprint(rutas_bp, url_prefix='/rutas')


    from app.menu import bp as menu_bp
    app.register_blueprint(menu_bp, url_prefix='/menu')


    from app.visitas import bp as visitas_bp
    app.register_blueprint(visitas_bp, url_prefix='/visitas')

    from app.rondas import bp as rondas_bp
    app.register_blueprint(rondas_bp, url_prefix='/rondas')

    from app.rondaPunto import bp as rondaPunto_bp
    app.register_blueprint(rondaPunto_bp, url_prefix='/rondaPunto')
    
    @app.route('/')
    def index():
        endpoints = []
        for rule in app.url_map.iter_rules():
            endpoints.append(str(rule))
        return jsonify(endpoints=endpoints)
    


    @app.route('/generate_token', methods=['POST'])
    @cross_origin()
    def generate_token():
        try:
           # Obtener el usuario y contraseña del cuerpo de la solicitud JSON
            data = request.get_json()
            user = data.get('username')  # El campo 'username' debe contener el nombre de usuario
            password = data.get('password')  # El campo 'password' d
            # Verificar que el usuario y la contraseña sean válidos
            if user == "SAMM23" and password == "SAMM23$$":
                # Si el usuario y la contraseña son válidos, crear el token de acceso con el ID del usuario como identidad.
                # En este caso, se utiliza '123' como ID del usuario, pero puedes cambiarlo según tu lógica de autenticación.
                user_codigo = "admin"
                access_token = create_access_token(identity=user_codigo)
                return jsonify({'access_token': access_token}), 200
            else:
                # Si las credenciales son incorrectas, retornar un error de autenticación
                return jsonify({'message': 'Credenciales inválidas'}), 401
            

        except Exception as e:
            return jsonify({'message': str(e)}), 500

    
    return app