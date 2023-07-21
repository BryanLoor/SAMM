import axios from 'axios';

//const API_URL = 'https://flask-production-f285.up.railway.app';
const API_URL = 'http://127.0.0.1:5000';
// Create an Axios instance with default headers
const axiosInstance = axios.create({
    baseURL: API_URL,
});

// Add a request interceptor to include the JWT token in the headers
axiosInstance.interceptors.request.use(
    function (config) {
        const token = localStorage.getItem('jwtToken');
        if (token) {
            config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
    },
    function (error) {
        return Promise.reject(error);
    }
);

export async function get(url: string) {
    try {
        const response = await axiosInstance.get(url);
        return response.data;
    } catch (error) {
        throw error;
    }
}

export async function post(url: string, data: any) {
    try {
        const response = await axiosInstance.post(url, data);
        return response.data;
    } catch (error) {
        throw error;
    }
}

export async function put(url: string, data: any) {
    try {
        const response = await axiosInstance.put(url, data);
        return response.data;
    } catch (error) {
        throw error;
    }
}

export async function remove(url: string) {
    try {
        const response = await axiosInstance.delete(url);
        return response.data;
    } catch (error) {
        throw error;
    }
}