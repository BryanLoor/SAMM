import React, { useContext, useEffect, useRef, useState } from "react";
import SidebarContext from "context/SidebarContext";
import SidebarContent from "./SidebarContent";
import Avatar from "@mui/material/Avatar";
import Typography from "@mui/material/Typography";
import Grid from "@mui/material/Grid";
import { get } from "utils/services/api";
import { Usuario } from "utils/models/usuario";
import { Persona } from "utils/models/persona";
import { rawListeners } from "process";

function DesktopSidebar() {
  const sidebarRef = useRef(null);
  const { saveScroll } = useContext(SidebarContext);
  const [user, setUser] = useState(new Usuario());
  const [persona, setPersona] = useState(new Persona());
  const [role, setRole] = useState();
  const linkClickedHandler = () => {
    saveScroll(sidebarRef.current);
  };

  const getRol = async (id: string) => {
    const rol = await get("/menu/getRolByID/" + id);
    console.log(rol.Rol.Codigo);
    setRole(rol.Rol.Codigo);
  };

  const getPersona = async (id: string) => {
    try {
      const persona = await get("/visitas/personas/" + id);
      setPersona(persona.persona);
      console.log(persona);
    } catch (error) {
      console.error(error, "error");
    }
  };

  useEffect(() => {
    const getUser = () => {
      const user = localStorage.getItem("user");
      if (user) {
        setUser(JSON.parse(user));
        getRol(JSON.parse(user).IdPerfil);
        getPersona(JSON.parse(user).IdPersona);
      }
    };
    getUser();
  }, []);

  return (
    <aside
      id="desktopSidebar"
      ref={sidebarRef}
      className="z-30 flex-shrink-0 hidden w-66 overflow-y-auto bg-[#001554] dark:bg-gray-800 lg:block"
    >
      <Grid container alignItems="center" spacing={2} className="p-6">
        <Grid item>
          <Avatar alt={persona?.Nombres} src="/path/to/avatar.jpg" />
        </Grid>
        <Grid item>
          <div className="text-center text-white">
            <Typography className="text-lg font-sans font-bold">
              {persona?.Nombres} {persona?.Apellidos}
            </Typography>
            <Typography className="text-lg font-sans font-bold">
              {role}
            </Typography>
            <Typography className="text-base font-sans">
              {persona?.Identificacion}
            </Typography>
          </div>
        </Grid>
      </Grid>
      <hr />
      <SidebarContent linkClicked={linkClickedHandler} />
    </aside>
  );
}

export default DesktopSidebar;
