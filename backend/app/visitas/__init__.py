from flask import Blueprint
from flask_cors import CORS



bp = Blueprint('visitas', __name__)

cors = CORS(bp,resources={r"/*": {"origins": "*", "headers":["Content-Type"]}})

from app.visitas import registraVisita
from app.visitas import Persona
from app.visitas import viewCalendar
from app.visitas import rondas
from app.visitas import roles
from app.visitas import usuario
# Path: backend\app\login\login.py