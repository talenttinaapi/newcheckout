import { test, expect } from "@playwright/test";

test.describe("Login page", () => {
  test("Page content", async ({ page }) => {
    await page.goto("/app/login");
    await expect(
      page.getByRole("heading", { name: "Welcome back!" }),
    ).toBeVisible();
    await expect(page.getByTestId("text-input-email")).toBeVisible();
  });

  test("Wrong email entered", async ({ page }) => {
    await page.goto("/app/login");
    await page.getByTestId("text-input-email").fill("incorrect00@test.com");
    await page.getByTestId("submit-button-login-email-next").click();
    await expect(page.getByTestId("inline-alert-error")).toBeVisible();
  });

  test("Forgotton password content", async ({ page }) => {
    await page.goto("/app/login/forgot-password");
    await expect(
      page.getByRole("heading", { name: "Don't worry!" }),
    ).toBeVisible();
    await expect(page.getByTestId("text-input-email")).toBeVisible();
  });

  test("Register page content", async ({ page }) => {
    await page.goto("/app/login/register");
    await expect(page.getByRole("heading", { name: "Welcome!" })).toBeVisible();
    await expect(page.getByTestId("text-input-email")).toBeVisible();
  });
});
