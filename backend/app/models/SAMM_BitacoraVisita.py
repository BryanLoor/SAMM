from app.extensions import db, PrimaryKeyConstraint
from app.extensions import ma
from marshmallow import Schema, fields
class SAMM_BitacoraVisita(db.Model):
    __tablename__ = 'SAMM_BitacoraVisita'
    __table_args__ = {'schema':'SAMM.dbo'}

    Id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    # Codigo = db.Column(db.String(30))
    Descripcion = db.Column(db.String(200))
    IdAnfitrion = db.Column(db.Integer)
    IdVisita = db.Column(db.Integer)
    FechaTimeVisitaEstimada = db.Column(db.DateTime)
    FechaTimeVisitaReal = db.Column(db.DateTime)
    UsuarioCrea = db.Column(db.String(255))
    UsuarioModifica = db.Column(db.String(255))
    FechaCrea = db.Column(db.DateTime)
    FechaModifica = db.Column(db.DateTime)
    Estado = db.Column(db.Integer)
    Observaciones = db.Column(db.String(300))
    IdUbicacion = db.Column(db.Integer)
    Duracion = db.Column(db.Integer)
    # Hora = db.Column(db.String(50))
    Placa = db.Column(db.String(50))
    FechaTimeSalidaEstimada = db.Column(db.DateTime)
    FechaTimeSalidaReal = db.Column(db.DateTime)
    Telefono = db.Column(db.String(20))
    Correo = db.Column(db.String(255))
    # Ubicacion = db.Column(db.String(255))
    Antecedentes = db.Column(db.Boolean, default=0)
    NombresVisitante = db.Column(db.String(255))
    ApellidosVisitante = db.Column(db.String(255))
    IdentificacionVisitante = db.Column(db.String(14))
    # NombresAnfitrion = db.Column(db.String(255))
    # ApellidosAnfitrion = db.Column(db.String(255))
    Alertas = db.Column(db.String(255))


class SAMM_BitacoraVisitaSchema(ma.SQLAlchemyAutoSchema):

    class Meta:
        model=SAMM_BitacoraVisita