from app.models.SAMM_Opcion import SAMM_Opcion, SAMM_OpcionSchema
from app.models.SAMM_Rol import SAMM_Rol, SAMM_RolSchema
from app.models.SAMM_OpRol import SAMM_OpRol, SAMM_OpRolSchema
from app.models.SAMM_RolUsu import SAMM_RolUsu, SAMM_RolUsuSchema
from app.models.SAMM_Usuario import SAMM_Usuario, SAMM_UsuarioSchema


from flask import jsonify, request
from flask_cors import cross_origin
from app.menu import bp
from app.extensions import db
from sqlalchemy import text
import base64
from flask_jwt_extended import jwt_required, get_jwt_identity
from datetime import date, datetime
from sqlalchemy import or_, and_

#plataforma: WEB || MOBILE
@bp.route('/getMenu/<string:plataforma>', methods=['GET'])
@cross_origin()
@jwt_required()
def getMenu(plataforma):
    try:
        # Obtener el ID del usuario autenticado
        current_user = get_jwt_identity()

        # Consulta SQL para obtener las opciones de menú
        opciones = (
            db.session.query(
                SAMM_Opcion.Id,
                SAMM_Opcion.Codigo,
                SAMM_Opcion.Estado,
                SAMM_Opcion.FechaCrea,
                SAMM_Opcion.UsuarioCrea,
                SAMM_Opcion.FechaModifica,
                SAMM_Opcion.UsuarioModifica,
                SAMM_Opcion.FechaUltimoLogin,
                SAMM_Opcion.Descripcion,
                SAMM_Opcion.Icon
            )
            .join(SAMM_OpRol, SAMM_Opcion.Id == SAMM_OpRol.IdOpcion)
            .join(SAMM_Usuario, SAMM_Usuario.IdPerfil == SAMM_OpRol.idRol)
            .filter(SAMM_Usuario.Codigo == current_user, SAMM_Opcion.Estado == 'A', SAMM_Opcion.Tipo == plataforma)
            .all()
        )

        # Serializar las opciones en una lista de objetos JSON
        opcion_schema = [

            {
                'Id': opcion.Id,
                'Codigo': opcion.Codigo,
                'Estado': opcion.Estado,
                'FechaCrea': opcion.FechaCrea,
                'UsuarioCrea': opcion.UsuarioCrea,
                'FechaModifica': opcion.FechaModifica,
                'UsuarioModifica': opcion.UsuarioModifica,
                'FechaUltimoLogin': opcion.FechaUltimoLogin,
                'Descripcion': opcion.Descripcion,
                'Icon': opcion.Icon
            }
            for opcion in opciones
        ]

        return jsonify(opcion_schema), 200
    except Exception as e:
        return jsonify({'message': str(e)}), 500
