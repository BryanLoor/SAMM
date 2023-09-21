from flask import Blueprint
from flask_cors import CORS

bp = Blueprint('rondaPunto', __name__)

cors = CORS(bp,resources={r"/*": {"origins": "*", "headers":["Content-Type"]}})

from app.rondaPunto import getRondaPuntosxRonda
from app.rondaPunto import createRondaPuntoxRonda
from app.rondaPunto import updateRondaPunto