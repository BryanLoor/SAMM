import Link from "next/link";
import routes, { IRoute, routeIsActive } from "routes/sidebar";
import * as Icons from "icons";
import { IIcon } from "icons";
import SidebarSubmenu from "./SidebarSubmenu";
import { useRouter } from "next/router";
import { useEffect, useState } from "react";
import { get } from "utils/services/api";

function Icon({ icon, ...props }: IIcon) {
  // @ts-ignore
  const Icon = Icons[icon];
  return <Icon {...props} />;
}

interface ISidebarContent {
  linkClicked: () => void;
}

function SidebarContent({ linkClicked }: ISidebarContent) {
  const { pathname } = useRouter();
  const [menu, setMenu] = useState<IRoute[]>([]);

  useEffect(() => {
    let routesT: IRoute[] = [];
    const menuT = localStorage.getItem('menu');
    if (menuT) {
      const menuTJson = JSON.parse(menuT);
      menuTJson.map((item: any) => {
        routesT.push({
          name: item.Descripcion,
          icon: item.Icon ? item.Icon : 'HomeIcon',
          path: '/' + item.path,
          exact: item.Id==1 ? true : false,
        });
      });
      setMenu(routesT);
    }
  }, []);
  
  const appName = process.env.NEXT_PUBLIC_APP_NAME;

  return (
    <div className="m-8 bg-white rounded-xl">
      <div className="text-[#0040AE] dark:text-gray-400 mt-8 p-2">
        <h1 className="ml-6 text-[#001554] font-sans font-semibold ">Menú</h1>
        <ul>
          {menu.map((route) =>
            route.routes ? (
              <SidebarSubmenu
                route={route}
                key={route.name}
                linkClicked={linkClicked}
              />
            ) : (
              <li className="relative px-6 py-3" key={route.name}>
                <Link href={route.path || "#"} scroll={false} legacyBehavior>
                  <a
                    className={`inline-flex items-center w-full text-sm font-semibold transition-colors duration-150 hover:text-gray-800 dark:hover:text-gray-200 ${
                      routeIsActive(pathname, route)
                        ? "dark:text-gray-100 text-[#001554]"
                        : ""
                    }`}
                    onClick={linkClicked}
                  >
                    {routeIsActive(pathname, route) && (
                      <span
                        className="absolute inset-y-0 left-0 w-1 bg-[#0040AE] rounded-tr-lg rounded-br-lg"
                        aria-hidden="true"
                      ></span>
                    )}

                    <Icon
                      className="w-5 h-5"
                      aria-hidden="true"
                      icon={route.icon || ""}
                    />
                    <span className="ml-4">{route.name}</span>
                  </a>
                </Link>
              </li>
            )
          )}
        </ul>

        {/* <div className="px-6 my-6">
          <Button>
            Create account
            <span className="ml-2" aria-hidden="true">
              +
            </span>
          </Button>
        </div> */}
      </div>
    </div>
  );
}

export default SidebarContent;
