import axios from "axios";

export default async function loginUser(credentials: any) {
  try {
    const response = await axios.post("/login", credentials);
    return response.data;
  } catch (error: any) {
    throw new Error(error.response.data.message);
  }
}
