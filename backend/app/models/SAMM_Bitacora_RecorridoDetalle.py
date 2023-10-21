from app.extensions import db, PrimaryKeyConstraint
from app.extensions import ma
from marshmallow import Schema, fields
class SAMM_Bitacora_RecorridoDetalle(db.Model):
    __tablename__ = 'SAMM_Bitacora_RecorridoDetalle'
    __table_args__ = {'schema':'SAMM.dbo'}

    Id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    IdUsuario = db.Column(db.Integer)
    IdRonda = db.Column(db.Integer)
    Estado = db.Column(db.String)
    IdPuntoRonda = db.Column(db.Integer)
    Codigo = db.Column(db.String)
    Descripcion = db.Column(db.String)
    FotoURL = db.Column(db.String)
    FechaCreacion = db.Column(db.DateTime)
    UsuCreacion = db.Column(db.Integer)
    FechaModifica = db.Column(db.DateTime)
    UsuModifica = db.Column(db.DateTime)
    IdBitacoraRecorrido = db.Column(db.Integer)
    

class SAMM_Bitacora_RecorridoDetalleSchema(ma.SQLAlchemyAutoSchema):

    class Meta:
        model=SAMM_Bitacora_RecorridoDetalle