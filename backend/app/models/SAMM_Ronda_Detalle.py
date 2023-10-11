from app.extensions import db, PrimaryKeyConstraint
from app.extensions import ma

class SAMM_Ronda_Detalle(db.Model):
    __tablename__ = 'SAMM_Ronda_Detalle'
    __table_args__ = {'schema':'SAMM.dbo'}

    Id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    IdUsuario = db.Column(db.Integer)
    IdRonda = db.Column(db.Integer)
    Estado = db.Column(db.String)
    IdPuntoRonda = db.Column(db.Integer)
    Codigo = db.Column(db.String)
    Descripcion = db.Column(db.String)
    FotoURL = db.Column(db.String)


class SAMM_Ronda_DetalleSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model=SAMM_Ronda_Detalle