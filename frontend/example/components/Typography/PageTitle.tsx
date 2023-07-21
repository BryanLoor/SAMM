import React from "react";

interface IPageTitle {
  children: React.ReactNode;
}

function PageTitle({ children }: IPageTitle) {
  return (
    <h1 className="mt-6 mb-2 text-xl font-medium text-[#001554] font-sans dark:text-gray-200">
      {children}
    </h1>
  );
}

export default PageTitle;
