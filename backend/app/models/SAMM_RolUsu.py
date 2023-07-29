from app.extensions import db, PrimaryKeyConstraint
from app.extensions import ma

class SAMM_RolUsu(db.Model):
    __tablename__ = 'SAMM_RolUsuario'
    __table_args__ = {'schema':'SAMM.dbo'}

    Id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    IdUsuario = db.Column(db.Integer)
    IdRol = db.Column(db.Integer)
    FechaCrea = db.Column(db.DateTime)
    UsuarioCrea = db.Column(db.Integer)
    FechaModifica = db.Column(db.DateTime)
    UsuarioModifica = db.Column(db.Integer)
    Estado = db.Column(db.String)

class SAMM_RolUsuSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model=SAMM_RolUsu