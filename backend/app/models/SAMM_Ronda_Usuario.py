from app.extensions import db, PrimaryKeyConstraint
from app.extensions import ma

class SAMM_Ronda_Usuario(db.Model):
    __tablename__ = 'SAMM_Ronda_Usuario'
    __table_args__ = {'schema':'SAMM.dbo'}

    Id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    IdRonda = db.Column(db.Integer)
    IdUsuario = db.Column(db.Integer)
    Estado = db.Column(db.String(1))
    FechaCrea = db.Column(db.DateTime)
    UsuCrea = db.Column(db.Integer)
    FechaMod = db.Column(db.DateTime)
    UsuMod = db.Column(db.Integer)



class SAMM_Ronda_UsuarioSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model=SAMM_Ronda_Usuario