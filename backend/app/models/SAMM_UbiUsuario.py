from  app.extensions import db, PrimaryKeyConstraint
from app.extensions import ma

class SAMM_UbiUsuario(db.Model):
    __tablename__ = 'SAMM_UbiUsuario'
    __table_args__ = {'schema':'SAMM.dbo'}

    Id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    IdUbicacion = db.Column(db.Integer)
    IdUsuario = db.Column(db.Integer)
    Estado =db.Column(db.String(1))
    UsuarioCrea = db.Column(db.Integer)
    UsuarioModifica = db.Column(db.Integer)
    EsAnfitrion = db.Column(db.String(1))
    FechaTimeCrea = db.Column(db.DateTime)
    FechaTimeModifica = db.Column(db.DateTime)
    FechaCrea = db.Column(db.Date)
    FechaModifica = db.Column(db.Date)

class SAMM_UbiUsuarioSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model=SAMM_UbiUsuario