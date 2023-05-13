
# 🍌 Null Text Prompt to Prompt editing

AKA editing a real image with text.

This is banana.dev conversion of https://github.com/google/prompt-to-prompt#editing-real-images

![example image of a woman changing her scarf color](./example.png)

## Usage

```js
import banana from "@banana-dev/banana-dev";
import fs from "fs/promises";

const apiKey = process.env.API_KEY;
const modelKey = process.env.MODEL_KEY;

const modelParameters = {
  image_base64: Buffer.from(await fs.readFile("./tay1.png")).toString("base64"),
  prompts: ["a woman with blonde hair and a blue scarf", "a woman with blonde hair and a yellow scarf"],
  blend_word: [["blue"], ["yellow"]],
  eq_params: { words: ["yellow"], values: [2] },
  num_inference_steps: 50,
  guidance_scale: 7.5,
  height: 512,
  width: 512,
  cross_replace_steps: { default_: 0.8 },
  self_replace_steps: 0.5,
  seed: new Date().getTime(),
};

try {
  const res = await banana.run(apiKey, modelKey, modelParameters);
  const { image_base64 } = res.modelOutputs[0];
  console.log("in:", JSON.stringify(modelParameters));
  delete res.modelOutputs[0].image_base64;
  console.log("res:", JSON.stringify(res));

  const img = Buffer.from(image_base64, "base64");
  await fs.writeFile("./out.png", img);
} catch (ex) {
  console.error("ERROR", ex);
  process.exit(1);
}
```

## Use Banana for scale.
