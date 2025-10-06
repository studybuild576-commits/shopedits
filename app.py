import gradio as gr
from rembg import remove
import PIL.Image

def remove_background(image):
    # Background remove karega
    output_image = remove(image)
    return output_image

# Gradio ka web interface banayein
iface = gr.Interface(
    fn=remove_background,
    inputs=gr.Image(type="pil", label="Yahan Image Upload Karein"),
    outputs=gr.Image(type="pil", label="Background Hati Hui Image"),
    title="AI Background Remover",
    description="Kisi bhi image ka background hatane ke liye use upload karein."
)

# Web app ko launch karein
iface.launch()
