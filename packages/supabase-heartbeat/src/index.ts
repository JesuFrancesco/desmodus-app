import { SupabaseConfig } from "./types/types";
import { handler } from "./service";
import dotenv from "dotenv";

dotenv.config();

const configs = {
  desmodusDB: {
    dbUrl: process.env.SUPABASE_URL || "Unauthorized",
    dbAnonKey: process.env.SUPABASE_ANON_KEY || "Unauthorized",
  },
} satisfies SupabaseConfig;

handler(configs);
