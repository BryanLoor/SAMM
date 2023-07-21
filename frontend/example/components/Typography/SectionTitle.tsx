import React from "react";

interface ISectionTitle {
  children: React.ReactNode;
}

function SectionTitle({ children }: ISectionTitle) {
  return (
    <h2 className="mb-4 text-lg font-medium text-[#001554] font-sans dark:text-gray-300">
      {children}
    </h2>
  );
}

export default SectionTitle;
