from flask import Blueprint
from flask_cors import CORS

bp = Blueprint('visitas', __name__)

cors = CORS(bp,resources={r"/*": {"origins": "*", "headers":["Content-Type"]}})

from app.visitas import visita