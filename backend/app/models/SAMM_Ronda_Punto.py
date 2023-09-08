from app.extensions import db, PrimaryKeyConstraint
from app.extensions import ma

class SAMM_Ronda_Punto(db.Model):
    __tablename__ = 'SAMM_Ronda_Punto'
    __table_args__ = {'schema':'SAMM.dbo'}

    Id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    IdRonda = db.Column(db.Integer)
    Orden = db.Column(db.Integer)
    Coordenada = db.Column(db.String(255))
    Estado = db.Column(db.Integer)
    FechaCreacion = db.Column(db.DateTime)
    UsuCreacion = db.Column(db.Integer)
    FechaModificacion = db.Column(db.DateTime)
    UsuModifica = db.Column(db.Integer)
    CodigoPunto = db.Column(db.String(100))
    Descripcion = db.Column(db.String(255))


class SAMM_Ronda_PuntoSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model=SAMM_Ronda_Punto