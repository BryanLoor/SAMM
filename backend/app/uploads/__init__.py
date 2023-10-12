from flask import Blueprint
from flask_cors import CORS

bp = Blueprint('uploads', __name__)

cors = CORS(bp,resources={r"/*": {"origins": "*", "headers":["Content-Type"]}})

from app.uploads import files