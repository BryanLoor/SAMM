/**
 * ⚠ These are used just to render the Sidebar!
 * You can include any link here, local or external.
 *
 */


interface IRoute {
  path?: string;
  icon?: string;
  name: string;
  routes?: IRoute[];
  checkActive?(pathname: String, route: IRoute): boolean;
  exact?: boolean;
}



export function routeIsActive(pathname: String, route: IRoute): boolean {
  if (route.checkActive) {
    return route.checkActive(pathname, route);
  }

  return route?.exact
    ? pathname == route?.path
    : route?.path
    ? pathname.indexOf(route.path) === 0
    : false;
}

const routes: IRoute[] = [];



    const menu = JSON.parse(localStorage.getItem("menu"));
  
    for (const item of menu) {
      const route = {
        path: item.path,
        icon: item.icon,
        name: item.Descripcion,
      };
  
      routes.push(route);
    }
  }

export type { IRoute };
export default routes;


// const routes: IRoute[] = [
//   {
//     path: "/example", // the url
//     icon: "HomeIcon", // the component being exported from icons/index.js
//     name: "Propiedades", // name that appear in Sidebar
//     exact: true,
//   },
//   {
//     path: "/example/agentes",
//     icon: "PeopleIcon",
//     name: "Agentes",
//   },
//   {
//     path: "/example/registro-visitas",
//     icon: "FormsIcon",
//     name: "Registro Visitas",
//   },
//   // {
//   //   path: "/example/bitacora-digital",
//   //   icon: "ChartsIcon",
//   //   name: "Bitácora Digital",
//   // },

//   {
//     path: "/example/registro-rondas",
//     icon: "FormsIcon",
//     name: "Registro Rondas",
//   },

// ];

