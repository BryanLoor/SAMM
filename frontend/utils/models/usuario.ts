/*model of usuario":{
        Id = db.Column(db.Integer, primary_key=True)
    Codigo = db.Column(db.String(50))
    Clave = db.Column(db.String(255))
    IdPersona = db.Column(db.Integer)
    IdPerfil = db.Column(db.Integer)
    Estado = db.Column(db.String(1))
    FechaCrea = db.Column(db.DateTime)
    UsuarioCrea = db.Column(db.Integer)
    FechaModifica = db.Column(db.DateTime)
    UsuarioModifica = db.Column(db.Integer)
    FechaUltimoLogin = db.Column(db.DateTime)
    Confirmado = db.Column(db.String(1))
    FechaConfirmacion = db.Column(db.DateTime)
    Pin= db.Column(db.String(4))
}
*/
export class Usuario {
    Id: number;
    Codigo: string;
    Clave: string;
    IdPersona: number;
    IdPerfil: number;
    Estado: string;
    FechaCrea: Date;
    UsuarioCrea: number;
    FechaModifica: Date;
    UsuarioModifica: number;
    FechaUltimoLogin: Date;
    Confirmado: string;
    FechaConfirmacion: Date;
    Pin: string;

    constructor() {
        this.Id = 0;
        this.Codigo = '';
        this.Clave = '';
        this.IdPersona = 0;
        this.IdPerfil = 0;
        this.Estado = '';
        this.FechaCrea = new Date();
        this.UsuarioCrea = 0;
        this.FechaModifica = new Date();
        this.UsuarioModifica = 0;
        this.FechaUltimoLogin = new Date();
        this.Confirmado = '';
        this.FechaConfirmacion = new Date();
        this.Pin = '';
    }
}