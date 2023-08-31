import { useContext } from "react";
import SidebarContext, { SidebarProvider } from "context/SidebarContext";
import Sidebar from "example/components/Sidebar";
import Header from "example/components/Header";
import Main from "./Main";

interface ILayout {
  children: React.ReactNode;
}

function Layout({ children }: ILayout) {
  const { isSidebarOpen } = useContext(SidebarContext);

  return (
    <SidebarProvider>
      <Header />
      <div
        className={`flex h-screen dark:bg-gray-900 ${
          isSidebarOpen && "overflow-hidden"
        }`}
      >
        {/* <Sidebar /> */}
        <div className="back flex flex-col flex-1 w-full bg-gray-100">
          <Main>{children}</Main>
        </div>
      </div>
    </SidebarProvider>
  );
}

export default Layout;
