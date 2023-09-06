from flask import Blueprint
from flask_cors import CORS

bp = Blueprint('rutas', __name__)

cors = CORS(bp,resources={r"/*": {"origins": "*", "headers":["Content-Type"]}})

from app.rutas import opcion,persona,roles,ronda,ubicacion,usuario,visitas