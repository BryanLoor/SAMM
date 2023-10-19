from app.extensions import db, PrimaryKeyConstraint
from app.extensions import ma
from marshmallow import Schema, fields
class SAMM_BitacoraRecorrido(db.Model):
    __tablename__ = 'SAMM_BitacoraRecorrido'
    __table_args__ = {'schema':'SAMM.dbo'}

    Id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    IdAgente = db.Column(db.Integer)
    IdRonda = db.Column(db.Integer)
    UsuCrea = db.Column(db.Integer)
    UsuMod = db.Column(db.Integer)
    FechaCrea = db.Column(db.DateTime)
    FechaMod = db.Column(db.DateTime)
    Estado = db.Column(db.String(1))
    

class SAMM_BitacoraRecorridoSchema(ma.SQLAlchemyAutoSchema):

    class Meta:
        model=SAMM_BitacoraRecorrido