import { useContext, useState } from "react";
import SidebarContext from "context/SidebarContext";
import { OutlineLogoutIcon } from "icons";
import {
  Dropdown,
  DropdownItem,
  WindmillContext,
} from "@roketid/windmill-react-ui";
import Image from "next/image";
import Avatar from "@mui/material/Avatar";
import { useRouter } from "next/router";

function Header() {
  const { mode, toggleMode } = useContext(WindmillContext);
  const { toggleSidebar } = useContext(SidebarContext);

  const [isNotificationsMenuOpen, setIsNotificationsMenuOpen] = useState(false);
  const [isProfileMenuOpen, setIsProfileMenuOpen] = useState(false);

  const router = useRouter();

  function handleNotificationsClick() {
    setIsNotificationsMenuOpen(!isNotificationsMenuOpen);
  }

  function handleProfileClick() {
    setIsProfileMenuOpen(!isProfileMenuOpen);
  }

  function handleLogout() {
     const confirmed = window.confirm("¿Estás seguro de cerrar sesión?");

     if (confirmed) {
       // Aquí deberías realizar las operaciones de cierre de sesión, como borrar tokens o limpiar el estado de autenticación.

       // Después de cerrar la sesión, redirecciona al usuario a la página de inicio de sesión.
       router.push("/example/login");
     }
  }

  // logo
  const imgSource =
    mode === "dark"
      ? "/assets/img/SAMM-horizontal2.png"
      : "/assets/img/SAMM-horizontal2.png";

  return (
    <header className="z-40 h-[80px] bg-[#0040AE] shadow-bottom dark:bg-gray-800">
      <div className="container flex items-center  justify-between h-full mx-auto text-purple-600 dark:text-purple-300">
        <ul>
          <Image
            aria-hidden="true"
            src={imgSource}
            alt="Office"
            width={150}
            height={20}
          />
        </ul>

        <ul className="flex items-center flex-shrink-0 space-x-6">
          <li className="relative">
            <button
              className="rounded-full focus:shadow-outline-purple focus:outline-none"
              onClick={handleProfileClick}
              aria-label="Account"
              aria-haspopup="true"
            >
              <Avatar alt="Avatar" src="/path/to/avatar.jpg" />
            </button>
            <Dropdown
              align="right"
              isOpen={isProfileMenuOpen}
              onClose={() => setIsProfileMenuOpen(false)}
            >
              <DropdownItem href="#" onClick={handleLogout}>
                <OutlineLogoutIcon
                  className="w-4 h-4 mr-3"
                  aria-hidden="true"
                />
                <span>cerrar sesión</span>
              </DropdownItem>
            </Dropdown>
          </li>
        </ul>
      </div>
    </header>
  );
}

export default Header;
