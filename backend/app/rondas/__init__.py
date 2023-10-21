from flask import Blueprint
from flask_cors import CORS

bp = Blueprint('rondas', __name__)

cors = CORS(bp,resources={r"/*": {"origins": "*", "headers":["Content-Type"]}})

from app.rondas import rondas
from app.rondas import guardias
from app.rondas import bitacora
from app.rondas import updatePuntoBitacoraRecorridoDetalle
