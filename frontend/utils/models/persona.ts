export class Persona {
    Id: number;
    TipoIde: string;
    Identificacion: string;
    Nombres: string;
    Apellidos: string;
    FechaNac: Date;
    EstadoCivil: string;
    Sexo: string;
    FechaCrea: Date;
    UsuarioCrea: number;
    FechaModifica: Date;
    UsuarioModifica: number;
    Tel_Domicilio: string;
    Tel_Trabajo: string;
    Correo_Domicilio: string;
    Correo_Trabajo: string;
    Dir_Domicilio: string;
    Dir_Trabajo: string;
    Cel_Personal: string;
    Cel_Trabajo: string;
    Cargo: string;
    Foto: string;
    NombreFoto: string;
    Mimetype: string;
    IdRol: number;
    Estado: string;

    constructor() {
        this.Id = 0;
        this.TipoIde = '';
        this.Identificacion = '';
        this.Nombres = '';
        this.Apellidos = '';
        this.FechaNac = new Date();
        this.EstadoCivil = '';
        this.Sexo = '';
        this.FechaCrea = new Date();
        this.UsuarioCrea = 0;
        this.FechaModifica = new Date();
        this.UsuarioModifica = 0;
        this.Tel_Domicilio = '';
        this.Tel_Trabajo = '';
        this.Correo_Domicilio = '';
        this.Correo_Trabajo = '';
        this.Dir_Domicilio = '';
        this.Dir_Trabajo = '';
        this.Cel_Personal = '';
        this.Cel_Trabajo = '';
        this.Cargo = '';
        this.Foto = '';
        this.NombreFoto = '';
        this.Mimetype = '';
        this.IdRol = 0;
        this.Estado = '';
    }
}