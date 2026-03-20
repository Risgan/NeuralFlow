import { TaskProvider } from "@/context/task-context";
import { AppShell } from "@/components/app-shell";

export default function Home() {
  return (
    <TaskProvider>
      <AppShell />
    </TaskProvider>
  );
}
