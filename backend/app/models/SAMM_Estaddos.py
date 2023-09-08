from app.extensions import db, PrimaryKeyConstraint
from app.extensions import ma

class SAMM_Estados(db.Model):
    __tablename__ = 'SAMM_Estados'
    __table_args__ = {'schema':'SAMM.dbo'}

    Id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    Tipo = db.Column(db.String(50))
    Codigo = db.Column(db.String(5))
    Descripcion = db.Column(db.String(255))

class SAMM_EstadosSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model=SAMM_Estados